class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id } # 同じ投稿への重複いいねを防ぐ
end
