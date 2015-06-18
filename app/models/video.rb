class Video < ActiveRecord::Base
  include Filterable

  scope :category, -> (category_title) { where category_title: category_title }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }

  serialize :tags

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end
end
