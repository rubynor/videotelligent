require 'open-uri'
require 'viddl-rb'

class Video < ActiveRecord::Base

  def self.import_all
    ContentProvider.all.map do |cp|
      account = Yt::Account.new(access_token: cp.valid_token)
      account.videos.map do |video|
        Video.new(
            uid: video.id,
            title: video.title,
            views: video.view_count,
            likes: video.like_count,
            dislikes: video.dislike_count,
            thumbnail_url: video.thumbnail_url
        )
      end
    end.flatten
  end

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end

  def download
    path = "public/videos"
    yt = ViddlRb.get_urls_names("https://www.youtube.com/watch?v=#{uid}").first
    File.open("#{path}/#{yt[:name]}", 'wb') do |video_file|
      open(yt[:url]) { |video| video_file.write video.read }
    end
    "#{path}/#{yt[:name]}"
  end
end
