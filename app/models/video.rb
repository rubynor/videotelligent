class Video < ActiveRecord::Base

  def self.import_all
    ContentProvider.all.map do |cp|
      account = Yt::Account.new(access_token: cp.valid_token, refresh_token: cp.refresh_token)
      account.content_owners.map do |content_owner|

        # TODO: Get all channels, not just the first
        # content_owner.partnered_channels.map do |channel|
        channel = content_owner.partnered_channels.first

        begin
          channel.videos.map do |video|
            Video.new(
                uid: video.id,
                title: video.title,
                views: video.view_count,
                likes: video.like_count,
                dislikes: video.dislike_count,
                thumbnail_url: video.thumbnail_url
            )
          end
        rescue Yt::Errors::RequestError => e
          if e.kind['code'] == 404
            []
          else
            raise e
          end
        end
      end
    end.flatten
  end

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end

end
