class PostsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = (current_user && current_user.admin?) ? Post.order(created_at: :desc) : Post.publish.order(created_at: :desc)
  end

  def show
    @post = Post.friendly.find(params[:id])
    redirect_to root_path if !@post.publish && current_user.nil?
    @pre_post = @post.pre_post
    @next_post = @post.next_post
  end

  def new
    @post = current_user.posts.new
    @category = Category.new
  end

  def edit
    redirect_to referer unless @current_user.can_manage?(@post)
    @category = Category.new
  end

  def create
    @post = current_user.posts.new(post_params)

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
      @post = current_user.posts.friendly.find(params[:id])
      redirect_to posts_url and return unless @post
      @page_title = @post.title
    end

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :publish)
    end
end
