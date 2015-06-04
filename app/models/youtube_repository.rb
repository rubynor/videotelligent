require 'open-uri'
require 'viddl-rb'

class YoutubeRepository
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

            video.save

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

  def self.download(video)
    yt = ViddlRb.get_urls_names("https://www.youtube.com/watch?v=#{video.uid}").first
    path = "public/videos/#{yt[:name]}"
    File.open(path, 'wb') do |video_file|
      open(yt[:url]) { |v| video_file.write v.read }
    end
    path
  end
end
