include ActionView::Helpers::DateHelper

namespace :view_stat do
  desc 'Merge weekly all view stat by week'
  task merge_all: :environment do
    start_date = ViewStat.select(:on_date)
                   .order('on_date').distinct
                   .where("on_date > '#{Date.new(2000)}'")
                   .first.on_date

    end_date = 1.week.ago.beginning_of_week

    Rake.application.invoke_task("view_stat:merge_by_date[#{start_date}, #{end_date}]")
  end

  desc 'Merge weekly from and to specific date: dateformat "yyyy-mm-dd"'
  task :merge_by_date, [:from, :to] => :environment do |_t, args|
    start_time = Time.now
    puts "Started merge at #{Time.now}"
    start_date = args[:from].to_date.beginning_of_week
    end_date = args[:to].to_date

    puts "Merge data from #{start_date} to #{end_date}"

    while start_date <= end_date
      puts "Start merge for date #{start_date}"
      ViewStat.merge_view_stats(from: start_date, to: start_date = start_date + 1.week)
    end
    end_time = Time.now
    puts "Merge ended at #{end_time} and took #{distance_of_time_in_words(end_time - start_time)} seconds"
  end
end
