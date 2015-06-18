class VideosController < ApplicationController
  def index
    orderby = params[:orderby] || 'views'
    order_direction = params[:orderDirection] || 'desc'

    @videos = Video.filter(params.slice(:category))
                  .search(params[:query])
                  .order(orderby => order_direction)
                  .paginate(page: params[:page], per_page: 24)

    respond_to do |format|
      format.html
      format.json { render json: @videos, meta: { total_videos: @videos.total_entries, orderby: orderby, orderDirection: order_direction } }
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
