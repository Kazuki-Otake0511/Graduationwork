class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]  # showアクションを含む
  before_action :authorize_user, only: [:edit, :update]   # 自分のアカウントだけ編集・更新できるようにする

  def index
    @users = User.page(params[:page]).per(10) # 1ページに10件のユーザーを表示
  end

  def show
    @posts = @user.posts.order(product_rank: :asc).page(params[:page]).per(5)
  end

  def new
    @user = User.new # 新しいUserオブジェクトを作成（空のフォームを表示するため）
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)  # Sorceryで自動ログイン
      redirect_to root_path, notice: t('flash.users.create_success')
    else
      logger.debug @user.errors.full_messages
      flash.now[:alert] = t('flash.users.create_failure') + ": " + @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @userはbefore_actionでセット済み
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: t('flash.users.update_success')
    else
      flash.now[:alert] = t('flash.users.update_failure') + ": " + @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "ユーザーが見つかりません"
    redirect_to users_path
  end

  # 現在のユーザーと編集対象のユーザーが一致するか確認する
  def authorize_user
    unless @user == current_user  # Sorceryの`current_user`を使ってログイン中のユーザーを取得
      flash[:alert] = "他のユーザーの情報は編集できません"
      redirect_to root_path  # トップページにリダイレクト
    end
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation,
      profile_attributes: [:hobby, :hometown, :profile_image]
    )
  end
end
