#encoding: utf-8
class SearchController < ApplicationController
  def index
    per_page = 20
    search_text = params[:q]
    search_text ||= ""
    @search = Post.where("title like ?", "%" << search_text << "%").order('published_at DESC').page(params[:page]).per(per_page)

    breadcrumb :search, search_text
    meta :title => "搜索：#{search_text}", :description => "搜索：#{search_text}的结果" , :keywords => search_text
  end

end
