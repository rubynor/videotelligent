class Video < ActiveRecord::Base
  include Filterable

  belongs_to :category
  has_many :view_stats

  before_save :set_default_values

  scope :category, -> (category_title) { where categories: { name: category_title } }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }

  scope :country, -> (country) {
    joins(:view_stats)
        .select("#{Video.quoted_table_name}.*, sum(view_stats.number_of_views) AS filtered_views")
        .where(view_stats: { country: country })
        .group('videos.id')
        .order('filtered_views desc')
  }

  serialize :tags

  # filtered_views is only defined if views filter (country, gender, age group) is set
  def filtered_views
    read_attribute(:filtered_views) || nil
  end

  private

  def set_default_values
    self.views_last_week ||= 0
  end
end
