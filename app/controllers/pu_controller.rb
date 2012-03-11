#encoding: utf-8
class PuController < ApplicationController
  def index
    if params[:p_id]
      @topic = Topic.find(params[:p_id])
      @page_urls = PageUrl.where("topic_id = ?", params[:p_id]).page(params[:page])
      #如果@page_urls为空 则返回
      return if @page_urls.blank?
      @page_url = @page_urls.first

      unless @page_url.status.eql?(1)
        t = TiebaTuoshuiJob.get_tieba_post(@topic, @page_url)
        @page_url.update_attributes!(:status => 1) if t == 1 #读取正确 状态为 1
        @page_url.update_attributes!(:status => 9) if t == 0 #读取出错 状态 改为 9
      end

      @posts = @page_url.tieba_posts if @topic.section_id.eql?(1)

    end

    #for seo
    breadcrumb :tb_detail, @topic
    meta :title => @topic.title ,
         :description => "#{ @topic.title}_脱水版本,作者:#{ @topic.author},第#{params[:page]}页" ,
         :keywords => @topic.author
  end
end
