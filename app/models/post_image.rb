class PostImage < ApplicationRecord
  belongs_to :post
  mount_uploader :image_url, ImageUploader

  # ファイルサイズを1MBに制限
  validate :validate_image_size

  private

  def validate_image_size
    if image_url.file && image_url.file.size > 1.megabytes
      errors.add(:image_url, "のサイズは1MB以内である必要があります")
    end
  end
end