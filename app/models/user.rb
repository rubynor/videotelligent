class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  has_one :content_provider, foreign_key: :uid, primary_key: :uid
  has_many :content_owners, through: :content_provider
  belongs_to :current_content_owner, class_name: 'ContentOwner'

  delegate :name, to: :content_provider

  def self.from_omniauth(auth)
    user = User.find_or_initialize_by(uid: auth['uid'])
    user.provider = auth['provider']
    user.email = auth['info']['email']
    user.image = auth['info']['image']
    user.password = Devise.friendly_token[0,20]

    user.save!
    user
  end
end
