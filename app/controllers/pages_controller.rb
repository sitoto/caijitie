class PagesController < ApplicationController
  caches_page :contact

  def home
    @recent_post = Post.published.where(:homepageable => true).last
    @links = Link.where(:status => 1).order("paixu")
    render 'home', :layout => 'abstract'
  end

  def contact
  end

  def about
  end

end
