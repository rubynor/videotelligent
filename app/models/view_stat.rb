class ViewStat < ActiveRecord::Base

  belongs_to :video

  def self.merge_view_stats(to: 1.week.ago.beginning_of_week, from: (to - 1.week))
    # to_day = 1.week.ago.beginning_of_week
    # from_day = to_day - 1.week

    stats_in_period = ViewStat.where(on_date: from...to)

    stats = stats_in_period
      .select('video_id, country, gender, age_group, sum(number_of_views) as merged_views')
      .group(:video_id, :gender, :age_group, :country)


    stats_sum = 0
    stats.each do |stat|
      # need to temporarily set on_date to nil,
      # to prevent these new records to be
      # destroyed with the old ones..
      # TODO: Perhaps add a boolean 'merged'?
      stats_sum += stat.merged_views
      ViewStat.create(video_id: stat.video_id,
                      gender: stat.gender,
                      age_group: stat.age_group,
                      country: stat.country,
                      number_of_views: stat.merged_views,
                      on_date: nil
      )
    end

    # puts "Stats sum is #{stats_sum}"
    # puts "Items to be destroy is #{stats_in_period.count}"
    # puts "to destroy sum = #{stats_in_period.sum(:number_of_views)}"

    stats_in_period.destroy_all
    ViewStat.where(on_date: nil).update_all(on_date: from)
    stats
  end
end
