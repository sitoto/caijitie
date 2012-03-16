#encoding: utf-8
class RecentController < ApplicationController
  def index
    @topics = Topic.order("created_at DESC").page(params[:page])
    #for seo
    breadcrumb :list, '最近加入文章'
    meta :title => "最近加入文章", :description => "按照最近加入文章排序列表" , :keywords => "最近加入,文章,脱水"
  end

end
