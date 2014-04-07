#encoding: utf-8
class HotController < ApplicationController
  caches_page :index


  def index
    @topics = Topic.find(:all, :conditions => "top >= 1"  , :order => "id DESC", :limit => 50)

  end

end
