module Youtube
  class VideoImporter

    def initialize
      @excluded_channel_ids = ENV['EXCLUDED_CHANNEL_IDS'].split(',') if ENV['EXCLUDED_CHANNEL_IDS']
      @excluded_channel_ids ||= []
    end

    def import_all
      ContentProvider.all.map do |cp|
        import_for(cp)
      end.flatten
    end

    def import_for(content_provider)
      account = Yt::Account.new(access_token: content_provider.token, refresh_token: content_provider.refresh_token)
      account.content_owners.map do |content_owner|
        content_owner.partnered_channels.map do |channel|

          next if @excluded_channel_ids.include?(channel.id)

          begin
            channel.videos.map do |yt_video|
              video = to_video_from(Yt::Video.new(id: yt_video.id, auth: content_owner))
              video
            end
          rescue Yt::Errors::RequestError => e
            if e.kind['code'] == 404
              []
            else
              raise e
            end
          end
        end
      end
    end

    private
    def to_video_from(yt_video)
      video = Video.find_or_initialize_by(uid: yt_video.id)
      puts "Starting import of video #{yt_video.title}"

      video.uid = yt_video.id
      video.title = yt_video.title
      video.views = yt_video.view_count
      video.views_last_week = yt_video.views(since: 1.week.ago)[:total]
      video.likes = yt_video.like_count
      video.dislikes = yt_video.dislike_count
      video.thumbnail_url = yt_video.thumbnail_url(:medium)
      video.description = yt_video.description
      video.published_at = yt_video.published_at
      video.channel_title = yt_video.channel_title
      video.channel_id = yt_video.channel_id
      video.category = Category.find_by_external_reference(yt_video.category_id)
      video.save

      yt_video.views(by: :country).map do |country, total_views|
        yt_video.viewer_percentage(in: { country: country }).map do |gender, percentages|
          percentages.map do |age_group, percentage|
            view_stat = ViewStat.find_or_initialize_by(video_id: video.id,
                                                       country: country,
                                                       gender: gender,
                                                       age_group: age_group)

            view_stat.number_of_views = ((total_views * percentage) / 100).floor
            view_stat.save
          end
        end.flatten(1)
      end.flatten(1)

      video
    end

  end
end