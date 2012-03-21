#encoding: utf-8
class PuController < ApplicationController
  def index
    if params[:p_id]
      @topic = Topic.find(params[:p_id])
      @page_urls = PageUrl.where("topic_id = ?", params[:p_id]).page(params[:page])
      #如果@page_urls为空 则返回
      return if @page_urls.blank?
      @page_url = @page_urls.first

      if (@page_url.status != 1 && @page_url.status != 2)
        @page_url.update_attributes!(:status => 2)

        t = TiebaTuoshuiJob.get_tieba_post(@topic, @page_url) if @topic.section_id == 1
        t = TianyabbsTuoshuiJob.get_tianyabbs_post(@topic, @page_url) if @topic.section_id == 2
        t = DoubanhuatiTuoshuiJob.get_doubanhuati_post(@topic, @page_url) if @topic.section_id == 3

        @page_url.update_attributes!(:status => 1,:count => t ) if t >=  0 #读取正确 状态为 1
        @page_url.update_attributes!(:status => 9) if t == -1 #读取出错 状态 改为 9
      end

      @posts = @page_url.tieba_posts if @topic.section_id.eql?(1)
      @posts = @page_url.tianya_posts if @topic.section_id.eql?(2)
      @posts = @page_url.douban_posts if @topic.section_id.eql?(3)
      @topic.increment!(:myshowtimes, by = 1)
    end

    #for seo
    breadcrumb :tb_detail, @topic if @topic.section_id == 1
    breadcrumb :tysq_detail, @topic if @topic.section_id == 2
    breadcrumb :dbht_detail, @topic if @topic.section_id == 3
    meta :title => @topic.title ,
         :description => "#{ @topic.title}_脱水版本,作者:#{ @topic.author},第#{params[:page]}页" ,
         :keywords => @topic.author
  end
end
