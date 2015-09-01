module Youtube
  class SingleVideoImporter

    LOWER_TOTAL_VIEW_LIMIT = 10000
    LOWER_COUNTRY_VIEW_LIMIT = 5000
    LONG_TIME_AGO = Date.new(2000)

    ALL_AGE_GROUPS = %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)
    GENDERS = [:male, :female]
    AGE_GROUPS_BY_GENDER = GENDERS.product(ALL_AGE_GROUPS)

    def initialize(yt_video, countries_we_care_about)

      YoutubeRequestCounter.start_new_video!

      @yt_video = yt_video
      @video = Video.find_or_initialize_by(uid: yt_video.id)
      @interesting_countries = countries_we_care_about
    end

    def import_video
      return unless @yt_video.view_count && @yt_video.view_count >= LOWER_TOTAL_VIEW_LIMIT

      puts "Starting import of video #{@yt_video.title}"
      starting_time = Time.now.to_f

      import_video_itself

      if @video.new_record?
        import_baseline_view_stats

        dates_last_week_with_views.each do |day|
          import_view_stats_for_day(day)
        end
      else
        last_date_with_data = @video.view_stats.order(:on_date).last.on_date
        days_with_updated_views = @yt_video.views_by_day.select { |k, v| k > last_date_with_data && v }.keys

        days_with_updated_views.each do |day|
          @interesting_countries = @video.view_stats.map(&:country).uniq.reject { |c| c == "OTHER" }
          import_view_stats_for_day(day)
        end
      end

      @video.save!

      ending_time = Time.now.to_f

      puts "Import of #{@video.title} took #{ending_time - starting_time} seconds and used #{YoutubeRequestCounter.number_of_requests} requests"
      puts "Average is now #{YoutubeRequestCounter.average_number_of_requests_per_video} requests per video after #{YoutubeRequestCounter.total_number_of_videos} videos"

      @video
    end

    def import_video_itself
      @video.uid = @yt_video.id
      @video.title = @yt_video.title
      @video.views = @yt_video.view_count
      @video.views_last_week = @yt_video.views(since: 7.days.ago)[:total]
      @video.likes = @yt_video.like_count
      @video.dislikes = @yt_video.dislike_count
      @video.thumbnail_url = @yt_video.thumbnail_url(:medium)
      @video.description = @yt_video.description
      @video.published_at = @yt_video.published_at
      @video.channel_title = @yt_video.channel_title
      @video.channel_id = @yt_video.channel_id
      @video.category = Category.find_by_external_reference(@yt_video.category_id)
      @video.tags = @yt_video.tags
    end

    def dates_last_week_with_views
      dates_last_week = (1.week.ago.to_date...Date.today).to_a
      dates_with_no_views = @yt_video.dates_with_no_views
      puts "Dates last week with views#{dates_last_week - dates_with_no_views}"
      dates_last_week - dates_with_no_views
    end

    def import_baseline_view_stats
      puts "Importing baseline"

      views_in_countries_we_care_about = initial_demographic_view_hash

      countries_and_views = @yt_video.baseline_views_by_country.select { |country, views| @interesting_countries.include?(country) && views >= LOWER_COUNTRY_VIEW_LIMIT }
      @interesting_countries = countries_and_views.keys

      puts "Interesting countries: #{@interesting_countries}"

      if @interesting_countries.any?
        countries_and_views.each do |country, total_views|

          puts "\t\t Importing #{country}"


          @yt_video.baseline_viewer_percentage_in(country).each do |gender, percentages|
            percentages.each do |age_group, percentage|
              number_of_views = percentage_to_number(total_views, percentage)
              views_in_countries_we_care_about[gender][age_group] += number_of_views

              @video.view_stats << ViewStat.new(
                                       country: country,
                                       gender: gender,
                                       age_group: age_group,
                                       on_date: LONG_TIME_AGO,
                                       number_of_views: number_of_views)

            end
          end
        end
      end

      puts "# of requests after baseline Europe: #{YoutubeRequestCounter.number_of_requests}"

      # Insert combined "leftover rows" for baseline countries that are not part of COUNTRIES_WE_CARE_ABOUT
      puts "Importing consolidated viewstats"
      overall_viewer_percentage = @yt_video.baseline_viewer_percentage
      total_views = @yt_video.total_baseline_views

      views_in_all_countries = viewer_percentage_to_views(overall_viewer_percentage, total_views)

      AGE_GROUPS_BY_GENDER.each do |gender, age_group|
        next unless views_in_all_countries[gender] && views_in_all_countries[gender][age_group]

        number_of_views = views_in_all_countries[gender][age_group] - views_in_countries_we_care_about[gender][age_group]

        @video.view_stats << ViewStat.new(
                                 country: 'OTHER',
                                 gender: gender,
                                 age_group: age_group,
                                 on_date: LONG_TIME_AGO,
                                 number_of_views: number_of_views)

      end

      puts "# of requests after baseline notEurope: #{YoutubeRequestCounter.number_of_requests}"
    end

    def import_view_stats_for_day(day)
      puts "\t Importing for #{day}"

      day_views_in_countries_we_care_about = initial_demographic_view_hash

      if @interesting_countries.any?
        @yt_video.day_views_by_country(day).select { |country, _| @interesting_countries.include?(country) }.each do |country, total_views|
          puts "\t\t Importing country #{country} with a total of #{total_views} views"

          viewer_percentage = if total_views > 150 #todo check this number out
                                @yt_video.day_viewer_percentage_in(country, day)
                              else
                                {}
                              end
          if viewer_percentage.empty?
            puts "\t\t\tno stats for #{day} in #{country}, extrapolating using stats for last week"
            # This means that Youtube didn't want to give us statistics for a single day and country, so we're going to fetch the week stats and extrapolate on day
            viewer_percentage = @yt_video.last_weeks_viewer_percentage_in(country)
            if viewer_percentage.empty?
              puts "\t\t\tno stats for last week in #{country} either, extrapolating using stats for all time"
              viewer_percentage = @yt_video.total_viewer_percentage_in(country)
            end
          end

          viewer_percentage.each do |gender, percentages|
            percentages.each do |age_group, percentage|
              number_of_views = percentage_to_number(total_views, percentage)

              next unless number_of_views > 0
              @video.view_stats << ViewStat.new(
                                       country: country,
                                       gender: gender,
                                       age_group: age_group,
                                       on_date: day,
                                       number_of_views: number_of_views)

              day_views_in_countries_we_care_about[gender][age_group] += number_of_views
            end
          end
        end
      end

      # Insert combined "leftover rows" for given day for countries that are not part of COUNTRIES_WE_CARE_ABOUT
      total_day_viewer_percentage = @yt_video.day_viewer_percentage(day)

      if total_day_viewer_percentage.empty?
        total_day_viewer_percentage = @yt_video.last_weeks_viewer_percentage
      end

      day_views_in_all_countries = total_day_viewer_percentage.map do |gender, dist|
        [gender, dist.map do |age_group, percentage|
                 [age_group, percentage_to_number(percentage, @yt_video.total_views_on(day))]
               end.to_h]
      end.to_h

      AGE_GROUPS_BY_GENDER.each do |gender, age_group|
        next unless day_views_in_all_countries[gender] && day_views_in_all_countries[gender][age_group] && day_views_in_all_countries[gender][age_group] > 0

        number_of_views = day_views_in_all_countries[gender][age_group] - day_views_in_countries_we_care_about[gender][age_group]

        @video.view_stats << ViewStat.new(
                                 country: 'OTHER',
                                 gender: gender,
                                 age_group: age_group,
                                 on_date: day,
                                 number_of_views: number_of_views)

      end
    end

    private
    def percentage_to_number(percentage, total)
      percentage ||= 0
      total ||= 0
      ((percentage * total) / 100).round
    end

    def initial_demographic_view_hash
      views_by_age_group = ALL_AGE_GROUPS.map { |age_group| [age_group, 0] }.to_h
      GENDERS.map { |gender| [gender, views_by_age_group.dup] }.to_h
    end

    def viewer_percentage_to_views(percentage_hash, total_views)
      percentage_hash.map do |gender, distribution|
        views_by_age_group = distribution.map do |age_group, percentage|
          [age_group, percentage_to_number(percentage, total_views)]
        end.to_h
        [gender, views_by_age_group]
      end.to_h
    end

  end
end