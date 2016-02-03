require 'rails_helper'

RSpec.describe ViewStat, type: :model do
  describe 'merge_view_stats' do
    it 'finds all videos for the week before last and merge view stat' do
      countries = %w(NO OTHER)
      genders = %w(female male)
      age_groups = ['13-16', '18-24', '25-35']
      video_id = create(:video).id

      beginning_of_last_week = 1.week.ago.beginning_of_week.to_date
      start = beginning_of_last_week - 1.week
      long_time_ago = Date.today - 1.month

      countries.each do |country|
        genders.each do |gender|
          age_groups.each do |age|
            create :view_stat,
                   country: country,
                   gender: gender,
                   age_group: age,
                   video_id: video_id,
                   on_date: long_time_ago,
                   number_of_views: 20

            14.times do |n|
              create :view_stat,
                     country: country,
                     gender: gender,
                     age_group: age,
                     video_id: video_id,
                     on_date: start + n.days,
                     number_of_views: 20
            end
          end
        end
      end


      initial_stat_count = ViewStat.count
      atr_number = countries.length * genders.length * age_groups.length
      expected_deleted_data = atr_number*7

      # expect(videos_count).to eq(120)

      puts "stats from last week is #{ViewStat.where(on_date: start..beginning_of_last_week).count}"

      puts "ViewStat.count is #{ViewStat.count}"

      # ViewStat.merge_view_stats.each do |stat|
      #   puts stat.attributes.to_options
      # end


      # Even though We generate data for a lot of days
      # only 8 should be the outcome because of the merge
      # We have a total of 2 x 2 x 2 attributes that are groupes
      # = 8
      # expect do
      #   ViewStat.merge_view_stats
      # end.to change { ViewStat.count }.by(8)
      expect(ViewStat.merge_view_stats.length).to eq(atr_number)

      puts "stats from last week is #{ViewStat.where(on_date: start..beginning_of_last_week).count}"
      puts "ViewStat.count is #{ViewStat.count}"

      expect(ViewStat.count).to eq(initial_stat_count - (expected_deleted_data))

      expect do
        ViewStat.merge_view_stats
      end.not_to change { ViewStat.count }

      expect(ViewStat.last.number_of_views).to eq(20*7)

    end
  end
end
