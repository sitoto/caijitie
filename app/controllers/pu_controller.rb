#encoding: utf-8
class PuController < ApplicationController
  def index
    if params[:p_id]
      @topic = Topic.find(params[:p_id])
      @page_urls = PageUrl.where("topic_id = ?", params[:p_id]).page(params[:page])
    end

    #for seo
    breadcrumb :tb_list_detail, @topic
    meta :title => @topic.title ,
         :description => "#{ @topic.title}_脱水版本,作者:#{ @topic.author},第#{params[:page]}页" ,
         :keywords => @topic.author
  end
end
