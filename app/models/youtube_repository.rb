require 'open-uri'
require 'viddl-rb'

class YoutubeRepository
  def self.import_all
    Youtube::CategoryImporter.new.import_all
    Youtube::VideoImporter.new.import_all
  end

  def self.download_link(video)
    yt = ViddlRb.get_urls_names("https://www.youtube.com/watch?v=#{video.uid}").first
    filename = yt[:name].gsub(/[^0-9A-Za-z.\-]/, '_')
    "#{yt[:url]}&title=#{filename}"
  end

end
