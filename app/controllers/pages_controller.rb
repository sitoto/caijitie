class PagesController < ApplicationController
  caches_page :contact

  def home
    @recent_posts = Post.published.recent.where(:homepageable => true).limit(10)
    @topics = Topic.find(:all, :order => "id DESC", :limit => 20)
    #@funs = Fun.find(:all, :order => "id DESC", :limit => 10)
    @links = Link.where(:status => 1).order("paixu")
    render 'home', :layout => 'abstract'
  end

  def contact
  end

  def about
  end

end
