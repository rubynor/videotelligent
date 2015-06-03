class VideosController < ApplicationController
  def index
    @videos = Video.order(views: :desc).limit(3)
  end

  def new
    @video = Video.new
  end

  def create
  end

  def download
    @video = Video.find(params[:video_id])
    send_file "#{Rails.root}/#{@video.download}"
  end

end
