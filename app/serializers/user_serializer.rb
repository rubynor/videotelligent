class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :image

  has_many :content_owners
  has_one :current_content_owner
end
