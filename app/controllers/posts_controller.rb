class PostsController < ApplicationController
  # 共通処理として、特定の投稿を取得するメソッドを指定のアクションで実行する
  before_action :set_post, only: [:show, :edit, :update]

  # 一覧表示アクション
  def index
    # ページネーション付きで投稿を5件ずつ取得し、@postsに格納
    @posts = Post.page(params[:page]).per(5)
  end

  # 新規投稿フォームの表示アクション
  def new
    @post = Post.new  # 新しい投稿オブジェクトを作成
    @post.post_images.build  # 空のPostImageを準備して、フォームで画像アップロードを受け取れるようにする
  end

  # 投稿の作成アクション
  def create
    # 現在のユーザーに関連付けられた投稿を作成する
    @post = current_user.posts.build(post_params)

    # アップロードされたファイルの内容をログに出力（デバッグ用）
    Rails.logger.info "アップロードファイルの内容: #{params[:post][:post_images_files].inspect}"

    # 投稿を保存し、成功すれば画像も保存する
    if @post.save
      # post_images_filesが存在する場合に画像を保存する
      if params[:post][:post_images_files].present?
        save_post_images(@post, params[:post][:post_images_files])
      end
      flash[:success] = "投稿が作成されました！"  # 成功メッセージを表示
      redirect_to @post  # 投稿の詳細ページにリダイレクト
    else
      # 投稿の保存に失敗した場合、エラーメッセージを表示し、新規投稿フォームを再表示
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  # 投稿の編集フォームの表示アクション
  def edit
    # @post は set_post で取得済み
  end

  # 投稿の更新アクション
  def update
    # 更新が成功すれば、詳細ページにリダイレクト
    if @post.update(post_params)
      flash[:success] = "投稿が更新されました！"
      redirect_to @post
    else
      # 更新に失敗した場合、エラーメッセージを表示し、編集フォームを再表示
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  # 投稿の詳細表示アクション
  def show
    # @post は set_post で取得済み
  end

  private

  # 指定されたIDの投稿を取得するメソッド（共通化）
  def set_post
    @post = Post.find(params[:id])  # パラメータからIDを取得して投稿を探す
  rescue ActiveRecord::RecordNotFound
    # 投稿が見つからない場合の処理
    flash[:error] = "投稿が見つかりません"
    redirect_to posts_path  # 一覧ページにリダイレクト
  end

  # ストロングパラメータで許可されたパラメータのみを取得する
  def post_params
    params.require(:post).permit(
      :product_name, :product_rank, :recommendation_points, :purchase_link
    )
  end

  # 画像を保存するためのメソッド
  def save_post_images(post, image_files)
    # 渡された画像ファイルの配列を1つずつ処理
    image_files.each do |image|
      # デバッグ用に画像の内容をログに出力
      Rails.logger.info "処理中の画像: #{image.inspect}"

      # 画像が空か、適切なアップロードファイルでなければスキップ
      next if image.blank? || !image.is_a?(ActionDispatch::Http::UploadedFile)

      # 新しい PostImage オブジェクトを投稿に紐づけて作成
      post_image = post.post_images.build
      post_image.image_url = image  # CarrierWaveでの画像アップロード

      # 保存に成功した場合、成功メッセージをログに出力
      if post_image.save
        Rails.logger.info "画像が保存されました: #{post_image.image_url.url}"
      else
        # 保存に失敗した場合、エラーメッセージをログに出力
        Rails.logger.error "画像の保存に失敗しました: #{post_image.errors.full_messages.join(', ')}"
      end
    end
  end
end
