class HomeController < ApplicationController
  def index
    @post = Post.publish.last
  end

  def about
  end

  def feed
    @posts = Post.publish.order(created_at: :desc)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def four_oh_four
    raise ActionController::RoutingError.new(params[:path])
  end
end
