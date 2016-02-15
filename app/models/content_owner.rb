class ContentOwner < ActiveRecord::Base
  belongs_to :content_provider
  has_many :videos, primary_key: :uid
end
