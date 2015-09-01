class VideoSerializer < ActiveModel::Serializer
  attributes :id, :link, :title, :published_at, :likes, :dislikes, :uid, :thumbnail_url, :views, :download_path,
             :description, :channel_title, :tags, :views_last_week, :filtered_views

  has_one :category

  def download_path
    download_video_path(object)
  end
end
