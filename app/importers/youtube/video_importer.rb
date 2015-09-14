module Youtube
  class VideoImporter

    LOWER_COUNTRY_VIEW_LIMIT = 1000
    LONG_TIME_AGO = Date.new(2000)

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
      account = Yt::Account.new(access_token: content_provider.token, refresh_token: content_provider.refresh_token)
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
      puts "Starting import of video #{yt_video.title}"
      starting_time = Time.now.to_i

      video.uid = yt_video.id
      video.title = yt_video.title
      video.views = yt_video.view_count
      video.views_last_week = yt_video.views(since: 1.week.ago)[:total] || 0
      video.likes = yt_video.like_count
      video.dislikes = yt_video.dislike_count
      video.thumbnail_url = yt_video.thumbnail_url(:medium)
      video.description = yt_video.description
      video.published_at = yt_video.published_at
      video.channel_title = yt_video.channel_title
      video.channel_id = yt_video.channel_id
      video.category = Category.find_by_external_reference(yt_video.category_id)
      video.save

      # Import "baseline"
      yt_video.views(by: :country, until: 1.week.ago).each do |country, total_views|
        yt_video.viewer_percentage(in: { country: country }, since: 1.week.ago).each do |gender, percentages|
          percentages.each do |age_group, percentage|
            view_stat = ViewStat.find_or_initialize_by(video_id: video.id,
                                                       country: country,
                                                       gender: gender,
                                                       age_group: age_group,
                                                       on_date: LONG_TIME_AGO)

            view_stat.number_of_views = ((total_views * percentage) / 100).floor
            view_stat.save
          end
        end
      end

      # Import separately per day for the last week
      (1.week.ago.to_date...Date.today).each do |day|
        puts "\t Importing for #{day}"
        yt_video.views(by: :country, since: day, until: day).each do |country, total_views|
          yt_video.viewer_percentage(in: { country: country }, since: day, until: day).each do |gender, percentages|
            percentages.each do |age_group, percentage|
              view_stat = ViewStat.find_or_initialize_by(video_id: video.id,
                                                         country: country,
                                                         gender: gender,
                                                         age_group: age_group,
                                                         on_date: day)

              view_stat.number_of_views = ((total_views * percentage) / 100).floor
              view_stat.save
            end
          end
        end
      end

      ending_time = Time.now.to_i

      puts "Import of #{video.title} took #{ending_time - starting_time} seconds"


      video
    end

  end
end