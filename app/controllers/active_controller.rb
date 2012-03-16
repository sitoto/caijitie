#encoding: utf-8
class ActiveController < ApplicationController
  def index
    @topics = Topic.order("myupdatetime DESC").page(params[:page])
    #for seo
    breadcrumb :download, '最近更新的文章'
    meta :title => "最近更新的文章", :description => "按照最近更新文章排序列表" , :keywords => "最近更新,文章,脱水"
  end

end
