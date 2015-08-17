module Youtube
  class CategoryImporter

    def import_all
      yt_categories = Yt::Collections::VideoCategories.new.where(part: 'snippet', region_code: 'US')

      yt_categories.each do |yt_category|

        # TODO: Replace with a select on yt_categories when this PR is merged: https://github.com/Fullscreen/yt/pull/119
        next unless yt_category.snippet.data['assignable']

        category = Category.find_or_initialize_by(external_reference: yt_category.id)
        category.name = yt_category.title
        category.save
      end
    end

  end
end