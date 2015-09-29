FactoryGirl.define do
  factory :content_provider do |c|
    c.sequence(:refresh_token) { |n| "RefreshToken_#{n}" }
  end
end
