namespace :videos do
  desc "Import videos into our database from youtube and update categories"
  task import: :environment do
    videos = YoutubeRepository.import_all
    puts "Total of #{videos.size} imported/refreshed"
  end

  task clean: :environment do
    ViewStat.delete_all
    Category.delete_all
    Video.delete_all
  end
end
