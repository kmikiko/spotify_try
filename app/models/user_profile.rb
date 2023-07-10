class UserProfile < ApplicationRecord
  belongs_to :user, inverse_of: :user_profile
  # has_one_attached :icon
  mount_uploader :icon, ImageUploader
end
