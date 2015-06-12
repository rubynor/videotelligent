class Video < ActiveRecord::Base
  include Filterable

  scope :category, -> (category_title) { where category_title: category_title }

  serialize :tags

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end
end
