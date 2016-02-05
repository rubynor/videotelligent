require 'rails_helper'

RSpec.describe ViewStat, type: :model  do
  describe 'merge_view_stats', order: :defined do

    before(:all) do
      countries = %w(NO OTHER)
      genders = %w(female male)
      age_groups = ['13-16', '18-24', '25-35']
      video_id = create(:video).id

      beginning_of_last_week = 1.week.ago.beginning_of_week.to_date
      start = beginning_of_last_week - 1.week
      @long_time_ago = Date.today - 1.month

      countries.each do |country|
        genders.each do |gender|
          age_groups.each do |age|
            create :view_stat,
                   country: country,
                   gender: gender,
                   age_group: age,
                   video_id: video_id,
                   on_date: @long_time_ago,
                   number_of_views: 10

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

      @initial_view_sum = ViewStat.sum(:number_of_views)

      @initial_stat_count = ViewStat.count
      @atr_number = countries.length * genders.length * age_groups.length
      @expected_deleted_data = @atr_number*6
    end

    it 'finds all videos for the week before last and merge view stat' do
      expect(ViewStat.merge_view_stats.length).to eq(@atr_number)
      expect(ViewStat.count).to eq(@initial_stat_count - (@expected_deleted_data))

      expect do
        ViewStat.merge_view_stats
      end.not_to change { ViewStat.count }

      expect(ViewStat.last.number_of_views).to eq(20 * 7)

      expect(ViewStat.sum(:number_of_views)).to eq(@initial_view_sum)

      expect(ViewStat.merge_view_stats(to: @long_time_ago + 1.day).length).to eq(@atr_number)

      expect(ViewStat.last.number_of_views).to eq(10)

      expect(ViewStat.count).to eq(@initial_stat_count - (@expected_deleted_data))

      expect(ViewStat.sum(:number_of_views)).to eq(@initial_view_sum)
    end
  end
end
