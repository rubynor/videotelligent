namespace :videos do
  desc "Import videos into our database from youtube and update categories"
  task import: :environment do
    begin
      YoutubeRepository.import_all
    ensure
      Param.first.update_attribute(:last_week, 1.week.ago.to_date)
      VideosByView.refresh
    end
  end

  task clean: :environment do
    ViewStat.delete_all
    Category.delete_all
    Video.delete_all
    VideosByView.refresh
  end
end
