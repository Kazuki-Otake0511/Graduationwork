class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, inverse_of: :post, dependent: :destroy
  accepts_nested_attributes_for :post_images, allow_destroy: true
  # product_rankが1位から10位の間であることをバリデート
  validates :product_rank, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validate :validate_post_images_count

  private

  def validate_post_images_count
    if post_images.size > 5
      errors.add(:post_images, "は5枚までアップロードできます")
    end
  end
end
