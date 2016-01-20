class VideosController < ApplicationController

  RANGES_TO_DATES = {
      'views' => Youtube::SingleVideoImporter::LONG_TIME_AGO,
      'views_last_week' => 1.week.ago.to_date,
  }

  def index
    order_by = params[:order_by] || 'views'

    @videos = if filter_params?
                Video.with_views_filtered
                  .filter(params.slice(:category, :country, :gender, :age_group))
                  .since(RANGES_TO_DATES[order_by])
              else
                Video.with_views_non_filtered
              end

    @videos = @videos.search(params[:query]).paginate(page: params[:page], per_page: 24)

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

  private

  def filter_params?
    params[:category] || params[:country] || params[:gender] || params[:age_group]
  end
end
