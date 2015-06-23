require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'creates categories from video categories' do
    create :video
    expect do
      Category.import_all
    end.to change { Category.count }.by(1)
  end

  it 'ignores create category for nil category_title' do
    create :video, category_title: nil
    expect do
      Category.import_all
    end.to_not change { Category.count }
  end
end
