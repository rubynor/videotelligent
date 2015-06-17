class VideosController < ApplicationController
  def index
    params[:query].downcase! if params[:query]
    @videos = Video.filter(params.slice(:category))
                  .where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{params[:query]}%")
                  .order(views: :desc)
                  .paginate(page: params[:page], per_page: 24)

    respond_to do |format|
      format.html
      format.json { render json: @videos, meta: { total_videos: @videos.total_entries } }
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
