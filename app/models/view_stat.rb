class ViewStat < ActiveRecord::Base

  belongs_to :video

  def self.merge_view_stats(to_day: 1.week.ago.beginning_of_week, from_day: (to_day - 1.week))
    # to_day = 1.week.ago.beginning_of_week
    # from_day = to_day - 1.week
    stats = ViewStat.where(on_date: from_day...to_day)
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

    ViewStat.where(on_date: from_day..to_day).destroy_all
    ViewStat.where(on_date: nil).update_all(on_date: from_day)
    stats
  end
end
