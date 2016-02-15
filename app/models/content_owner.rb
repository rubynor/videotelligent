class ContentOwner < ActiveRecord::Base
  belongs_to :content_provider
  has_many :videos
end
