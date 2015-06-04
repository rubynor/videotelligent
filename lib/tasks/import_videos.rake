namespace :videos do
  desc "Import videos into our database from youtube"
  task import: :environment do
    YoutubeManager.import_all
  end
end
