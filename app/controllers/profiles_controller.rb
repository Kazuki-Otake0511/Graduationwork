class ProfilesController < ApplicationController
  # ログインユーザーのプロフィールを事前に取得して設定
  before_action :set_profile  # ログインユーザーのプロフィールを設定

  # プロフィール編集画面の表示
  def edit
    # @profileはbefore_actionでセットのためコードの追加はなし
  end

  # プロフィール更新処理
  def update
    # フォームから送信されたデータでプロフィールを更新
    if @profile.update(profile_params)
      # 更新が成功した場合、トップページにリダイレクトし、成功メッセージを表示
      redirect_to root_path, notice: t('flash.profiles.update')
    else
      # 更新が失敗した場合、エラーメッセージを設定して再度編集画面を表示
      flash.now[:alert] = @profile.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private

   # ログイン中のユーザーのプロフィールを取得
   # current_user.profileでログイン中のユーザーのプロフィールを取得し、@profileにセット
  def set_profile
    @profile = current_user.profile
  end

  # プロフィール更新時に許可するパラメータ
  # :hobby, :hometown, :profile_imageのフィールドのみを許可
  def profile_params
    params.require(:profile).permit(:hobby, :hometown, :profile_image)
  end
end
