class Profile < ApplicationRecord
  belongs_to :user

  # CarrierWaveのアップローダーをマウントする
  mount_uploader :profile_image, ProfileImageUploader
end
