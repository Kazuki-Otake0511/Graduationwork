class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, inverse_of: :post, dependent: :destroy
  accepts_nested_attributes_for :post_images, allow_destroy: true

  # product_rankが1位から10位の間であることをバリデート
  validates :product_rank, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validate :validate_post_images_count
  validate :unique_rank_for_user  # 同じユーザーで同じランキングの投稿を禁止する

  # 投稿と画像をトランザクションで保存する
  def save_with_images(image_files:)
    ActiveRecord::Base.transaction do
      save!  # 投稿を保存

      # 画像があれば関連付けて保存
      image_files&.each do |image|
        post_images.create!(image_url: image)
      end
    end
    true
  rescue StandardError => e
    errors.add(:base, "画像の保存に失敗しました: #{e.message}")
    false
  end

  private

  def unique_rank_for_user
    if Post.exists?(user_id: user_id, product_rank: product_rank)
      errors.add(:product_rank, "このランキング順位はすでに使用されています")
    end
  end

  # 画像の数をバリデーション
  def validate_post_images_count
    if post_images.length > 5
      errors.add(:post_images, "は5枚までアップロードできます")
    end
  end
end