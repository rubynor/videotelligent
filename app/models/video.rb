class Video < ActiveRecord::Base

  serialize :tags

  def self.import_all
    ContentProvider.all.map do |cp|
      account = Yt::Account.new(access_token: cp.valid_token, refresh_token: cp.refresh_token)
      account.content_owners.map do |content_owner|

        # TODO: Get all channels, not just the first
        # content_owner.partnered_channels.map do |channel|
        channel = content_owner.partnered_channels.first

        begin
          channel.videos.map do |yt_video|

            video = Video.find_by_uid(yt_video.id) || Video.new

            video.uid = yt_video.id
            video.title = yt_video.title
            video.views = yt_video.view_count
            video.likes = yt_video.like_count
            video.dislikes = yt_video.dislike_count
            video.thumbnail_url = yt_video.thumbnail_url
            video.description = yt_video.description
            video.tags = yt_video.tags

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
    end.flatten
  end

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end

end
