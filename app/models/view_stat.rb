class ViewStat < ActiveRecord::Base

  belongs_to :video

  def self.merge_view_stats(from:, to:)
    stats_in_period = ViewStat.where(on_date: from...to)

    grouped_stats = stats_in_period
      .select('video_id, country, gender, age_group, sum(number_of_views) as merged_views')
      .group(:video_id, :gender, :age_group, :country)

    stats_to_be_created = grouped_stats.map do |stat|
      ViewStat.new(video_id: stat.video_id,
                      gender: stat.gender,
                      age_group: stat.age_group,
                      country: stat.country,
                      number_of_views: stat.merged_views,
                      on_date: from
      )
    end

    ActiveRecord::Base.transaction do
      stats_in_period.destroy_all
      stats_to_be_created.map(&:save!)
    end
  end
end
