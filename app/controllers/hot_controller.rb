#encoding: utf-8
class HotController < ApplicationController
  def index
    @topics = Topic.find(:all, :conditions => "status = 1"  , :order => "id DESC", :limit => 50)

    #for seo
    breadcrumb :list, '推荐列表'
    meta :title => "回复最多文章", :description => "按照回复最多文章排序列表" , :keywords => "回复最多,文章,脱水"
  end

end
