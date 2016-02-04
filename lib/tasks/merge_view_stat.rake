namespace :view_stat do
  desc 'Merge all view stat by week'
  task merge_all: :environment do
    time = Time.now
    puts "Started merge at #{time}"
    start_date = ViewStat.select(:on_date).order('on_date').distinct[1].on_date

    while start_date <= 1.week.ago.beginning_of_week
      puts "Start merge for date #{start_date}"
      ViewStat.merge_view_stats(to: start_date)
      start_date = start_date + 1.week
    end

    end_time = Time.now
    puts "Merge ended at #{end_time} and took #{end_time - time} seconds"
  end
end
