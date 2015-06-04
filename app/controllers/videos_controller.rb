class VideosController < ApplicationController
  def index
    @videos = Video.order(views: :desc)

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
end
