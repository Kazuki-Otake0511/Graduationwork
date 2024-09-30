class SessionsController < ApplicationController
  # ログインページの表示
  # GETリクエストでログインページを表示するアクション
  def new
  end

  # ログイン処理
  # POSTリクエストで送信されたログイン情報を処理するアクション
  def create
    # 入力されたメールアドレスとパスワードでユーザーを認証
    user = User.authenticate(session_params[:email], session_params[:password])
    
    if user
      # 認証に成功した場合、自動的にログイン
      auto_login(user)  # Sorceryの機能でユーザーをログインさせる
      # ログインに成功した場合、rootページにリダイレクトし、成功メッセージを表示
      redirect_to root_path, notice: t('flash.sessions.login_success')
    else
      # 認証に失敗した場合、エラーメッセージをフラッシュメッセージで表示
      flash.now[:danger] = t('flash.sessions.login_failure')
      # ログインページを再表示し、HTTPステータスコード422を返す
      render :new, status: :unprocessable_entity
    end
  end

  # ログアウト処理
  # DELETEリクエストでログアウトを処理するアクション
  def destroy
    # Sorceryの機能でログアウト
    logout  
    # ログアウト後、ログインページにリダイレクトし、成功メッセージを表示
    redirect_to login_path, notice: t('flash.sessions.logout_success')
  end

  private

  # ストロングパラメータ: ログイン時に許可するパラメータを指定
  # メールアドレスとパスワードのみを許可
  def session_params
    params.permit(:email, :password)
  end
end
