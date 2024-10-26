class RankingsController < ApplicationController
  def index
    # 各ユーザーの投稿を取得し、ランキング順に並び替える
    @users_with_posts = User.includes(:posts).map do |user|
      {
        user: user,
        posts: user.posts.order(product_rank: :asc)  # ランキング順にソート
      }
    end
  end
end
