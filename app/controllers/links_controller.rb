class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.all
  end

  def new
    @link = Link.new
  end

  def edit
  end

  def create
    @link = Link.new(link_params)

    if @link.save
      redirect_to links_url, notice: '新建成功'
    else
      flash.now[:error] = @link.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    if @link.update(link_params)
      redirect_to links_url, notice: '修改成功'
    else
      flash.now[:error] = @link.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @link.destroy
  end

  private

    def set_link
      @link = Link.find(params[:id])
      authorize @link
    end

    def link_params
      params.require(:link).permit(:title, :link)
    end
end
