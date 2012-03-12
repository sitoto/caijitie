#encoding: utf-8
class AuthorController < ApplicationController
  def show
    @topics = Topic.where("author = ?",params[:name]).order("id DESC").page(params[:page])
    #for seo
    breadcrumb :list,  '作者：'<< params[:name]
    meta :title => "作者：#{params[:name]} 发布的文章列表", :description => "作者：'#{params[:name]}'发布的文章列表" , :keywords => "#{params[:name]}"
  end

end
