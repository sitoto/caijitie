class PagesController < ApplicationController
  def home
    @recent_post = Post.published.where(:homepageable => true).last
    render 'home', :layout => 'abstract'
  end

  def contact
  end

  def about
  end

end
