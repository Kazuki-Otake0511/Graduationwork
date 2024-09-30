class UsersController < ApplicationController
  # ユーザーの編集や更新を行う際に、現在のユーザー情報を取得してセットする
  before_action :set_user, only: [:edit, :update]  

  # ユーザー新規登録ページの表示
  def new
    @user = User.new # 新しいUserオブジェクトを作成（空のフォームを表示するため）
  end

  # ユーザーの作成処理
  def create
    @user = User.new(user_params)  # フォームから送信されたデータを使って新しいUserオブジェクトを作成
    if @user.save  # ユーザーをデータベースに保存
      auto_login(@user)  # Sorceryで自動ログイン
      redirect_to root_path, notice: t('flash.users.create_success')   # 成功メッセージをフラッシュで表示し、トップページにリダイレクト
    else
      # 保存が失敗した場合、エラーメッセージをデバッグログに出力
      logger.debug @user.errors.full_messages
      # エラーメッセージをフラッシュにセットして表示、入力された内容を保持したまま再度フォームを表示
      flash.now[:alert] = t('flash.users.create_failure') + ": " + @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity  # HTTPステータス422を返し、新規登録ページを再表示
    end
  end

  # ユーザー編集ページの表示
  def edit
    # @userはbefore_actionでセットされています
  end

  # ユーザー情報の更新処理
  def update
    if @user.update(user_params) # フォームから送信されたデータでユーザー情報を更新
      redirect_to root_path, notice: t('flash.users.update_success') # 成功メッセージをフラッシュで表示し、トップページにリダイレクト
    else
      # 更新が失敗した場合、エラーメッセージをフラッシュにセットして表示
      flash.now[:alert] = t('flash.users.update_failure') + ": " + @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity # HTTPステータス422を返し、編集ページを再表示
    end
  end
  
  private

  # ログイン中のユーザーを設定するメソッド
  def set_user
    @user = current_user  # Sorceryでログインしているユーザーを取得
  end

  # ユーザー登録や更新時に許可するパラメータを指定するメソッド
  def user_params
    # name、email、password、password_confirmationの各フィールドに加え、
    # profileに関するデータ（hobby、hometown、profile_image）も受け取る
    params.require(:user).permit(:name, :email, :password, :password_confirmation, profile_attributes: [:hobby, :hometown, :profile_image])
  end
end
