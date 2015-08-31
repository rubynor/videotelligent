class Video < ActiveRecord::Base
  include Filterable

  belongs_to :category

  before_save :set_default_values

  scope :category, -> (category_title) { where 'categories.name' => category_title }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }

  serialize :tags

  def self.all_included
    excluded_channel_ids = ENV['EXCLUDED_CHANNEL_IDS'].split(',') if ENV['EXCLUDED_CHANNEL_IDS']
    self.includes(:category).where.not(channel_id: excluded_channel_ids)
  end

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end

  private

  def set_default_values
    self.views_last_week ||= 0
  end
end
