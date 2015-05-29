class VideosController < ApplicationController
  def index
    @videos = Video.import_all
    @videos.sort_by!(&:views).reverse!
  end

  def new
    @video = Video.new
  end

  def create
  end
end