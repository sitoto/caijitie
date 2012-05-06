class PagesController < ApplicationController
  caches_page :contact
  caches_page :home

  def home
    #@recent_posts = Post.published.recent.where(:homepageable => true).limit(10)
    @topics = Topic.find(:all, :order => "id DESC", :limit => 25)
    @re_topics = Topic.find(:all, :conditions => "top >= 1"  , :order => "id DESC", :limit => 20)
    @classes = Topic.find_by_sql("SELECT count(*) as count , classname  FROM `topics` GROUP BY classname  ORDER BY count DESC limit 18")
    #@funs = Fun.find(:all, :order => "id DESC", :limit => 10)
    @links = Link.where(:status => 1).order("paixu")
    render 'home', :layout => 'abstract'
  end

  def contact
  end

  def about
  end

end
