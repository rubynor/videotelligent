class VideosController < ApplicationController
  def index
    @videos = Video.order(views: :desc)
  end

  def new
    @video = Video.new
  end

  def create
  end
end