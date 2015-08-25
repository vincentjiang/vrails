class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = (current_user && current_user.has_role?(:admin)) ? Post.order(created_at: :desc) : Post.publish.order(created_at: :desc)
  end

  def show
    @pre_post = Post.where(id: @post.id - 1).first
    @next_post = Post.where(id: @post.id + 1).first
  end

  def new
    @post = Post.new
    authorize @post
    @category = Category.new
  end

  def edit
    @category = Category.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "创建文章 #{@post.title} 成功"
    else
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "修改文章 #{@post.title} 成功"
    else
      @category = Category.new
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "删除文章 #{@post.title} 成功"
  end

  private

    def set_post
      @post = Post.friendly.find(params[:id])
      unless current_user
        redirect_to posts_url and return unless @post.publish
      end
      authorize @post
      @page_title = @post.title
    end

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :publish)
    end
end
