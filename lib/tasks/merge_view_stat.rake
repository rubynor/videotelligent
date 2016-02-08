namespace :view_stat do
  desc 'Merge all view stat by week'
  task merge_all: :environment do
    start_time = Time.now
    puts "Started merge at #{start_time}"

    start_date = ViewStat.select(:on_date)
                   .order('on_date').distinct
                   .where("on_date > '#{Date.new(2000)}'")
                   .first.on_date

    while start_date <= 1.week.ago.beginning_of_week
      puts "Start merge for date #{start_date}"
      ViewStat.merge_view_stats(from: start_date, to: start_date = start_date + 1.week)
    end

    end_time = Time.now
    puts "Merge ended at #{end_time} and took #{end_time - start_time} seconds"
  end
end
