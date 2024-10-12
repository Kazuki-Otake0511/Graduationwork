class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]  # 投稿を取得する共通メソッドを使う

  def index
    @posts = Post.page(params[:page]).per(5) # 1ページに5件の投稿を表示
  end

  def new
    @post = Post.new
    5.times { @post.post_images.build }  # 最大5枚の画像をアップロードできるように空のPostImageを作成
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = "投稿が作成されました！"
      redirect_to @post
    else
      flash[:error] = @post.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @postはset_postメソッドで取得済み
    5.times { @post.post_images.build } if @post.post_images.empty?  # 画像投稿がなければ空のPostImageを作成
  end

  def update
    if @post.update(post_params)
      flash[:success] = "投稿が更新されました！"
      redirect_to @post
    else
      flash[:error] = @post.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    # @postはset_postメソッドで取得済み
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "投稿が見つかりません"
    redirect_to posts_path
  end

  def post_params
    params.require(:post).permit(:product_name, :product_rank, :recommendation_points, :purchase_link, :product_video, post_images_attributes: [:image_url])
  end
end
