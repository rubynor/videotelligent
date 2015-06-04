class VideoSerializer < ActiveModel::Serializer
  attributes :id, :link, :title, :published_at, :likes, :dislikes, :uid, :thumbnail_url, :views
end
