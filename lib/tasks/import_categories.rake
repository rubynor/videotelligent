namespace :categories do
  desc "Import categories"
  task import: :environment do
    categories = Category.import_all
    puts "Total of #{categories.count} categories imported/refreshed"
  end

  desc "Destroy all categories"
  task clean: :environment do
    Category.destroy_all
  end
end
