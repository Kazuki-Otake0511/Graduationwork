# app/controllers/likes_controller.rb
class LikesController < ApplicationController
    before_action :find_post
    before_action :find_post, only: [:create, :destroy]
  
    def create
      # ユーザーがまだ「いいね」していない場合のみ作成
      @post.likes.create(user: current_user) unless @post.liked_users.include?(current_user)
      redirect_to request.referer || @post  # 元のページに戻る
    end
  
    def destroy
      like = @post.likes.find_by(user: current_user)
      like&.destroy
      redirect_to request.referer || @post  # 元のページに戻る
    end

    def index
      # ログインユーザーが「いいね」した投稿を取得
      @liked_posts = current_user.liked_posts.includes(:user)
    end
  
    private
  
    def find_post
      @post = Post.find(params[:post_id])
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = t('flash.messages.login_required')
        redirect_to login_path
      end
    end
  end
  