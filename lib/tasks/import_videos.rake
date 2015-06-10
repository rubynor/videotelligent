namespace :videos do
  desc "Import videos into our database from youtube"
  task import: :environment do
    videos = YoutubeRepository.import_all
    puts "Total of #{videos.size} imported/refreshed"
  end

  task clean: :environment do
    Video.destroy_all
  end
end
