class User < ApplicationRecord
  authenticates_with_sorcery!
  authenticates_with_sorcery!  # Sorceryの認証機能を有効にする 

   # メールアドレスが必須かつユニークであることを確認
  validates :email, presence: true, uniqueness: true

  # 名前が必須であることを確認
  validates :name, presence: true

  # パスワードの長さを確認
  validates :password, presence: true, length: { minimum: 6 }

  # 管理者フラグ（is_admin）がBoolean型であることを確認
  validates :is_admin, inclusion: { in: [true, false] }

  # パスワード確認用フィールドのバリデーション（オプション）
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :password
end
