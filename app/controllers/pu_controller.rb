#encoding: utf-8
class PuController < ApplicationController

  def index
    if params[:p_id]
      p_id = params[:p_id]
      page_id = params[:page]
      @topic = Topic.find(p_id)

      @page_urls = PageUrl.where("topic_id = ?  and (status = 0 or count > 0)", @topic.id).page(page_id)
      #获取当前页前后有文章的页
      #如果@page_urls为空 则返回
      return if @page_urls.blank?
      @page_url = @page_urls.first

      if (@page_url.status != 1 && @page_url.status != 2)
        @page_url.update_attributes!(:status => 2)

        t = TiebaTuoshuiJob.get_tieba_post(@topic, @page_url) if @topic.rule == 1
        t = TianyabbsTuoshuiJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 2
        t = DoubanhuatiTuoshuiJob.get_doubanhuati_post(@topic, @page_url) if @topic.rule == 3
        t = TianyabbsTechforumJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 4

        @page_url.update_attributes!(:status => 1,:count => t ) if t >=  0 #读取正确 状态为 1
        @page_url.update_attributes!(:status => 9) if t == -1 #读取出错 状态 改为 9
      end

      @posts = @page_url.tieba_posts if @topic.section_id.eql?(1)
      @posts = @page_url.tianya_posts if @topic.section_id.eql?(2)
      @posts = @page_url.douban_posts if @topic.section_id.eql?(3)
      @topic.increment!(:myshowtimes, by = 1)

      @temp_topics = Topic.where("section_id = ?", @topic.section_id).order("id DESC").limit(10)
#获取当前页前后有文章的页
#@temp_pages = PageUrl.where("topic_id = ? and (status = 0 or count > 0)", @topic.id).limit(11)
#@temp_pages = PageUrl.where("topic_id = ? and (status = 0 or count > 0) and num > ?",  @topic.id, (page_id.to_i - 5)).limit(11)

    end

    #for seo
    breadcrumb :tb_detail, @topic if @topic.section_id == 1
    breadcrumb :tysq_detail, @topic if @topic.section_id == 2
    breadcrumb :dbht_detail, @topic if @topic.section_id == 3
    meta :title => @topic.title ,
         :description => "#{ @topic.title}_脱水版本,作者:#{ @topic.author},第#{params[:page]}页" ,
         :keywords => @topic.author

    #@fun = Fun.

  end
end
