namespace :videos do
  desc "Import videos into our database from youtube"
  task import: :environment do
    YoutubeRepository.import_all
  end
end
