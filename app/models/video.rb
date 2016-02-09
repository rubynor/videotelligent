class Video < ActiveRecord::Base
  include Filterable

  belongs_to :category
  has_many :view_stats
  has_many :videos_by_views

  before_save :set_default_values

  scope :with_views_non_filtered, -> {
    select("#{Video.quoted_table_name}.*, views AS filtered_views, views_last_week AS filtered_views_last_week")
        .order('views desc').includes(:category)
  }

  scope :with_views_filtered, -> {
    joins(:category)
        .joins(:videos_by_views)
        .select("#{Video.quoted_table_name}.*, sum(videos_by_views.filtered_views) AS filtered_views, sum(videos_by_views.filtered_views_last_week) AS filtered_views_last_week")
        .group('videos.id')
        .order('filtered_views desc')
  }
  scope :category, -> (category_title) { where categories: { name: category_title } }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }
  scope :country, -> (country) { where(videos_by_views: { country: country }) }
  scope :gender, -> (gender) { where(videos_by_views: { gender: gender }) }
  scope :age_group, -> (age_group) { where(videos_by_views: { age_group: age_group }) }

  serialize :tags

  def self.by_view_type(view)
    if view == 'views_last_week'
      reorder('filtered_views_last_week desc')
    else
      reorder('filtered_views desc')
    end
  end

  # filtered_views is only defined if views filter (country, gender, age group) is set
  def filtered_views
    read_attribute(:filtered_views) || nil
  end

  def filtered_views_last_week
    read_attribute(:filtered_views_last_week) || nil
  end

  def views_where(params)
    self.view_stats.where(params).map(&:number_of_views).sum
  end

  private

  def set_default_values
    self.views_last_week ||= 0
  end
end
