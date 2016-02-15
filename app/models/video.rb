class Video < ActiveRecord::Base
  include Filterable

  belongs_to :category
  belongs_to :content_owner, primary_key: :uid
  has_many :view_stats

  before_save :set_default_values

  scope :with_views, -> {
    joins(:category)
        .joins(:view_stats)
        .select("#{Video.quoted_table_name}.*, sum(view_stats.number_of_views) AS filtered_views")
        .group('videos.id')
        .order('filtered_views desc')
  }
  scope :category, -> (category_title) { where categories: { name: category_title } }
  scope :search, -> (query) { where('lower(title) LIKE :q OR lower(description) LIKE :q', q: "%#{query.try(:downcase)}%") }
  scope :country, -> (country) { where(view_stats: { country: country }) }
  scope :gender, -> (gender) { where(view_stats: { gender: gender }) }
  scope :age_group, -> (age_group) { where(view_stats: { age_group: age_group }) }
  scope :since, -> (from_date) { where(view_stats: { on_date: from_date...Date.today}) }
  scope :by_content_owner, -> (content_owner) { where(content_owner: content_owner) }

  serialize :tags

  # filtered_views is only defined if views filter (country, gender, age group) is set
  def filtered_views
    read_attribute(:filtered_views) || nil
  end

  def views_where(params)
    self.view_stats.where(params).map(&:number_of_views).sum
  end

  private

  def set_default_values
    self.views_last_week ||= 0
  end
end
