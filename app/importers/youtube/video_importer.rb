module Youtube
  class VideoImporter

    LOWER_COUNTRY_VIEW_LIMIT = 1000
    LONG_TIME_AGO = Date.new(2000)
    COUNTRIES_WE_CARE_ABOUT = %w(GG JE AX DK EE FI FO GB IE IM IS LT LV NO SE SJ AT BE CH DE DD
                            FR FX LI LU MC NLCZ HU MD PL RO RU SU SK UA AD AL BA ES GI GR
                            HR IT ME MK MT CS RS PT SI SM VA YU) # All countries in Europe, for now

    def initialize
      @excluded_channel_ids = ENV['EXCLUDED_CHANNEL_IDS'].split(',') if ENV['EXCLUDED_CHANNEL_IDS']
      @excluded_channel_ids ||= []
    end

    def import_all
      ContentProvider.all.each do |cp|
        import_for(cp)
      end
    end

    def import_for(content_provider)
      account = Yt::Account.new(refresh_token: content_provider.refresh_token)
      account.content_owners.each do |content_owner|
        content_owner.partnered_channels.each do |channel|

          next if @excluded_channel_ids.include?(channel.id)

          begin
            channel.videos.each do |yt_video|
              import_video(Yt::Video.new(id: yt_video.id, auth: content_owner))
            end
          rescue Yt::Errors::RequestError => e
            unless e.kind['code'] == 404
              raise e
            end
          end
        end
      end
    end


    def import_video(yt_video)
      video = Video.find_or_initialize_by(uid: yt_video.id)

      return unless yt_video.views[:total] >= 1000

      puts "Starting import of video #{yt_video.title}"
      starting_time = Time.now.to_f

      video.uid = yt_video.id
      video.title = yt_video.title
      video.views = yt_video.view_count
      video.views_last_week = yt_video.views(since: 7.days.ago)[:total]
      video.likes = yt_video.like_count
      video.dislikes = yt_video.dislike_count
      video.thumbnail_url = yt_video.thumbnail_url(:medium)
      video.description = yt_video.description
      video.published_at = yt_video.published_at
      video.channel_title = yt_video.channel_title
      video.channel_id = yt_video.channel_id
      video.category = Category.find_by_external_reference(yt_video.category_id)
      video.save

      # Import "baseline": all views

      baseline_date = 8.days.ago

      puts "Importing baseline"
      yt_video.views(by: :country, until: baseline_date).select{ |country,_| COUNTRIES_WE_CARE_ABOUT.include?(country)}.each do |country, total_views|
        yt_video.viewer_percentage(in: { country: country }, until: baseline_date).each do |gender, percentages|
          percentages.each do |age_group, percentage|
            view_stat = ViewStat.new(video_id: video.id,
                                                       country: country,
                                                       gender: gender,
                                                       age_group: age_group,
                                                       on_date: LONG_TIME_AGO)

            view_stat.number_of_views = ((total_views * percentage) / 100).round
            view_stat.save!
          end
        end
      end

      # Insert combined "leftover rows" for baseline countries that are not part of COUNTRIES_WE_CARE_ABOUT
      puts "Importing leftover rows"
      views_in_all_countries = Hash[yt_video.viewer_percentage(until: baseline_date).map do |gender, dist|
                                        [gender, Hash[dist.map do |age_group, percentage|
                                                        [age_group, ((percentage * yt_video.views(until: baseline_date)[:total]) / 100).round]
                                                      end]]
                                      end]
      [:male, :female].product(%w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).each do |gender, age_group|
        view_stat = ViewStat.new(video_id: video.id,
                                                   country: 'OTHER',
                                                   gender: gender,
                                                   age_group: age_group,
                                                   on_date: LONG_TIME_AGO)
        views_in_countries_we_care_about = ViewStat.where(video_id: video.id, gender: gender, age_group: age_group).map(&:number_of_views).sum || 0
        view_stat.number_of_views = (views_in_all_countries[gender][age_group] || 0)  - views_in_countries_we_care_about
        view_stat.save!
      end

      # Import separately per day for the last week
      (1.week.ago.to_date...Date.today).each do |day|
        puts "\t Importing for #{day}"
        yt_video.views(by: :country, since: day, until: day).select{ |country,_| COUNTRIES_WE_CARE_ABOUT.include?(country)}.each do |country, total_views|
          puts "\t\t Importing country #{country}"
          viewer_percentage = yt_video.viewer_percentage(in: { country: country }, since: day, until: day)
          if viewer_percentage.empty?
            puts "\t\t\tno stats for #{day} in #{country}, extrapolating"
            # This means that Youtube didn't want to give us statistics for a single day and country, so we're going to fetch the week stats and extrapolate on day
            viewer_percentage = yt_video.viewer_percentage(in: { country: country }, since: 1.week.ago)
            if viewer_percentage.empty?
              puts "\t\t\tno stats for last week in #{country} either, extrapolating even more"
              viewer_percentage = yt_video.viewer_percentage(in: { country: country })
            end
          end
          viewer_percentage.each do |gender, percentages|
            percentages.each do |age_group, percentage|
              puts "\t\t\t Importing #{gender}s aged #{age_group}: #{percentage}% of total"
              view_stat = ViewStat.new(video_id: video.id,
                                                         country: country,
                                                         gender: gender,
                                                         age_group: age_group,
                                                         on_date: day)

              view_stat.number_of_views = ((total_views * percentage) / 100).round
              view_stat.save!
            end
          end

          # Insert combined "leftover rows" for given day for countries that are not part of COUNTRIES_WE_CARE_ABOUT
          views_in_all_countries = Hash[yt_video.viewer_percentage(since: day, until: day).map do |gender, dist|
                                          [gender, Hash[dist.map do |age_group, percentage|
                                                          [age_group, ((percentage * yt_video.views(since: day, until: day)[:total]) / 100).round]
                                                        end]]
                                        end]
          [:male, :female].product(%w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).each do |gender, age_group|
            view_stat = ViewStat.new(video_id: video.id,
                                     country: 'OTHER',
                                     gender: gender,
                                     age_group: age_group,
                                     on_date: day)
            views_in_countries_we_care_about = ViewStat.where(video_id: video.id, gender: gender, age_group: age_group, on_date: day).map(&:number_of_views).sum || 0
            next unless views_in_all_countries && views_in_all_countries[gender]


            view_stat.number_of_views = (views_in_all_countries[gender][age_group] || 0)  - views_in_countries_we_care_about
            view_stat.save!
          end
        end

      end

      ending_time = Time.now.to_f

      puts "Import of #{video.title} took #{ending_time - starting_time} seconds"

      video
    end

  end
end