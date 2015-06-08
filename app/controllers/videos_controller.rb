class VideosController < ApplicationController
  def index
    @videos = Video.order(views: :desc).paginate(:page => params[:page], :per_page => 24)

    respond_to do |format|
      format.html
      format.json { render json: @videos }
    end
  end

  def show
    render json: Video.find(params[:id])
  end

  def new
    @video = Video.new
  end

  def create
  end

  def download
    @video = Video.find(params[:id])
    send_file "#{Rails.root}/#{YoutubeRepository.download(@video)}"
  end
end
