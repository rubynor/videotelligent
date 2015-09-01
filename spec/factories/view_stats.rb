FactoryGirl.define do
  factory :view_stat do
    country 'OTHER'
    on_date Date.yesterday
    number_of_views 10
  end
end
