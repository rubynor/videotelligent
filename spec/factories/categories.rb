FactoryGirl.define do
  factory :category do |c|
    c.sequence(:name) { |n| "CatName_#{n}" }
  end
end
