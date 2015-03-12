class StaticPagesController < ApplicationController
  def home
  	@project = current_user.projects.build if logged_in?
  	@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
