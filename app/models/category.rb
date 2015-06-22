class Category < ActiveRecord::Base
  def self.import_all
    Video.uniq.pluck(:category_title).map do |c|
      next unless c
      Category.find_or_create_by!(name: c)
    end
  end
end
