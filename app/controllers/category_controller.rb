#encoding: utf-8
class CategoryController < ApplicationController
  def show
    @topics = Topic.where("classname = ?",params[:name]).order("id DESC").page(params[:page])
    #for seo
    breadcrumb :list, '分类：'<< params[:name]
    meta :title => "#{params[:name]} 列表", :description => "目录：'#{params[:name]}'下的文章列表" , :keywords => "#{params[:name]}"
  end

end
