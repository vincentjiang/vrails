class CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.all
    authorize @categories
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.js
      else
        @errors = @category.errors.full_messages.join(", ")
        format.js
      end
    end
  end

  def destroy
    @category.destroy
  end

  private

    def set_category
      @category = Category.find(params[:id])
      authorize @category
    end

    def category_params
      params.require(:category).permit(:title)
    end
end
