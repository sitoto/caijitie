class PagesController < ApplicationController
  caches_page :contact

  def home
    @recent_post = Post.published.where(:homepageable => true).last
    @topics = Topic.find(:all, :order => "id DESC", :limit => 20)
    @links = Link.where(:status => 1).order("paixu")
    render 'home', :layout => 'abstract'
  end

  def contact
  end

  def about
  end

end
