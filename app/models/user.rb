class User < ApplicationRecord
  # Include default devise modules. Others available are:

  devise :database_authenticatable, :registerable, :timeoutable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable ,:omniauthable, omniauth_providers: %i(google)
  
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)
  
    unless user
      user = User.new(email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20],
                                   )
    end
    user.save
    user
  end

  has_one :user_profile, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :user_profile
end
