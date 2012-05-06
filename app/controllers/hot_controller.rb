#encoding: utf-8
class HotController < ApplicationController
  caches_page :index


  def index
    @topics = Topic.find(:all, :conditions => "top >= 1"  , :order => "id DESC", :limit => 50)

    #for seo
    breadcrumb :list, '推荐列表'
    meta :title => "推荐最多文章", :description => "按照推荐最多文章排序列表" , :keywords => "推荐最多,文章,脱水"
  end

end
