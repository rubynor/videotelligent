class VideosController < ApplicationController

  RANGES_TO_DATES = {
      'views' => Date.new(2000),
      'views_last_week' => 1.week.ago.to_date,
      'likes' => Date.new(2000) # TODO: This does not work now, but just to get it not to crash. Maybe.
  }

  def index
    order_by = params[:order_by] || 'views'

    @videos = Video.with_views
                  .filter(params.slice(:category, :country))
                  .since(RANGES_TO_DATES[order_by])
                  .search(params[:query])
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
