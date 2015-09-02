class CategoriesController < ApplicationController

  def index
    @categories = Category.all
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
    @category = Category.find(params[:id])
    @category.destroy
  end

  private

    def category_params
      params.require(:category).permit(:title)
    end

end
