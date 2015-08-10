class VideosController < ApplicationController
  def index
    order_by = params[:order_by] || 'views'

    @videos = Video.includes(:category)
                  .filter(params.slice(:category))
                  .search(params[:query])
                  .order(order_by => 'desc')
                  .paginate(page: params[:page], per_page: 24)

    respond_to do |format|
      format.html
      format.json { render json: @videos, meta: { total_videos: @videos.total_entries, order_by: order_by } }
    end
  end

  def show
    render json: Video.find(params[:id])
  end

  def download
    @video = Video.find(params[:id])
    redirect_to YoutubeRepository.download_link(@video)
  end
end
