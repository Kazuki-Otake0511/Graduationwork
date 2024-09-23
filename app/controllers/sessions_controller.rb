class SessionsController < ApplicationController
  # ログインページの表示
  def new
  end

  # ログイン処理
  def create
    user = User.authenticate(session_params[:email], session_params[:password])
    
    if user
      auto_login(user)  # Sorceryの機能でユーザーをログインさせる
      redirect_to root_path, notice: 'ログインに成功しました'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います'
      render :new, status: :unprocessable_entity
    end
  end

  # ログアウト処理
  def destroy
    logout  # Sorceryの機能でログアウト
    redirect_to login_path, notice: 'ログアウトしました'
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
