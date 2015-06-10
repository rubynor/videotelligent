class VideoSerializer < ActiveModel::Serializer
  attributes :id, :link, :title, :published_at, :likes, :dislikes, :uid, :thumbnail_url, :views, :download_path,
             :description, :category_title, :channel_title

  def download_path
    download_video_path(object)
  end
end
