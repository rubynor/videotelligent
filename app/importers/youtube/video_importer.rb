module Youtube
  class VideoImporter

    def import_all
      ContentProvider.all.map do |cp|
        import_for(cp)
      end.flatten
    end

    def import_for(content_provider)
      account = Yt::Account.new(access_token: content_provider.token, refresh_token: content_provider.refresh_token)
      account.content_owners.map do |content_owner|
        content_owner.partnered_channels.map do |channel|

          begin
            channel.videos.map do |yt_video|
              video = to_video_from(Yt::Video.new(id: yt_video.id, auth: content_owner))
              video.save
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
      video.category = Category.find_by_external_reference(yt_video.category_id)
      video
    end

  end
end