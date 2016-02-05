class ViewStat < ActiveRecord::Base

  belongs_to :video

  def self.merge_view_stats(to: 1.week.ago.beginning_of_week, from: (to - 1.week))
    stats_in_period = ViewStat.where(on_date: from...to)

    stats = stats_in_period
      .select('video_id, country, gender, age_group, sum(number_of_views) as merged_views')
      .group(:video_id, :gender, :age_group, :country)

    stats.each do |stat|
      # need to temporarily set on_date to nil,
      # to prevent these new records to be
      # destroyed with the old ones..
      # TODO: Perhaps add a boolean 'merged'?
      ViewStat.create(video_id: stat.video_id,
                      gender: stat.gender,
                      age_group: stat.age_group,
                      country: stat.country,
                      number_of_views: stat.merged_views,
                      on_date: nil
      )
    end

    stats_in_period.destroy_all
    # Need to update the date for all with nil
    ViewStat.where(on_date: nil).update_all(on_date: from)
    stats
  end
end
