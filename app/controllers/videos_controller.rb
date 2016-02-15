class VideosController < ApplicationController

  RANGES_TO_DATES = {
      'views' => Youtube::SingleVideoImporter::LONG_TIME_AGO,
      'views_last_week' => 1.week.ago.to_date,
  }

  def index
    order_by = params[:order_by] || 'views'
    @videos  = Video.with_views

    if current_user && current_user.current_content_owner
      @videos = @videos.by_content_owner(current_user.current_content_owner)
    end

    @videos = @videos.filter(params.slice(:category, :country, :gender, :age_group))
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
