class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_many :posts

  after_create :create_default_profile

  def self.ransackable_attributes(auth_object = nil)
    ["name", "email", "created_at", "updated_at"]
  end

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

  def create_default_profile
    #デフォルトのプロフィールを作成
    self.create_profile(hobby: "未設定", hometown: "未設定", profile_image: "default.png")
  end
end
