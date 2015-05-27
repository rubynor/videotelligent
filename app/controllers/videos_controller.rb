class VideosController < ApplicationController
  def index

    # TODO: Highly hard-coded
    channel = Yt::Channel.new(id: 'UCxO1tY8h1AhOz0T4ENwmpow')
    yt_videos = channel.videos

    @videos = yt_videos.map do |video|
      Video.new(
          uid: video.id,
          title: video.title,
          views: video.view_count,
          likes: video.like_count,
          dislikes: video.dislike_count,
          thumbnail_url: video.thumbnail_url
      )
    end

    @videos.sort_by!(&:views).reverse!

  end

  def new
    @video = Video.new
  end

  def create
  end
end