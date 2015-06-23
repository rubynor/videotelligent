class Video < ActiveRecord::Base
  include Filterable

  after_initialize :set_default_values

  scope :category, -> (category_title) { where category_title: category_title }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }

  serialize :tags

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end

  private

  def set_default_values
    self.views_last_week ||= 0
  end
end
