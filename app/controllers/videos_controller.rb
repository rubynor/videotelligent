class VideosController < ApplicationController
  def index
    @videos = Video.order(views: :desc)
  end

  def new
    @video = Video.new
  end

  def create
  end

  def download
    dummy_data
    @video = @videos.first
    if (path = @video.download)
      puts "url is #{path}"
      send_file "#{Rails.root}/#{path}"
    else
      fail 'Error'
    end
  end

  private

  def dummy_data
    videos = [{"id":nil,"link":nil,"title":"First YouTube App for Google Glass | Fullscreen BEAM","published_at":nil,"likes":808,"dislikes":162,"uid":"tMX1GQ1f4Vw","thumbnail_url":"https://i.ytimg.com/vi/tMX1GQ1f4Vw/default.jpg","created_at":nil,"updated_at":nil,"views":198419},{"id":nil,"link":nil,"title":"What is Fullscreen?","published_at":nil,"likes":1189,"dislikes":145,"uid":"NeMlqbX2Ifg","thumbnail_url":"https://i.ytimg.com/vi/NeMlqbX2Ifg/default.jpg","created_at":nil,"updated_at":nil,"views":88909}]

    @videos = videos.map do |video|
      puts video[:uid]
      Video.new(
          uid: video[:uid],
          title: video[:title],
          views: video[:views],
          likes: video[:likes],
          dislikes: video[:dislikes],
          thumbnail_url: video[:thumbnail_url]
      )
    end
  end
end
