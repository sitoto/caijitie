#encoding: utf-8
class PuController < ApplicationController
  caches_page :index
  #caches_action :index
  
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
        t = TianyabbsBbsJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 5

        @page_url.update_attributes!(:status => 1,:count => t ) if t >=  0 #读取正确 状态为 1
        @page_url.update_attributes!(:status => 9,:count => 0) if t == -1 #读取出错 状态 改为 9
      end

      @posts = @page_url.tieba_posts if @topic.section_id.eql?(1)
      @posts = @page_url.tianya_posts if @topic.section_id.eql?(2)
      @posts = @page_url.douban_posts if @topic.section_id.eql?(3)
      #@topic.increment!(:myshowtimes, by = 1)
      not_cai = PageUrl.count(:conditions => ["topic_id = ? and status = 0 ", @topic.id])
      if not_cai > 0  #存在为采集的页，本缓存失效
        all_page_num = PageUrl.count(:conditions => ["topic_id = ? ", @topic.id])
        1.upto(all_page_num) do |p|
         expire_page( :controller => "pu", :action => 'index' , :p_id => @topic.id, :page => p )
        end
      end
      #if @posts.blank?
        #expire_page( :controller => "pu", :action => 'index' , :p_id => @topic.id, :page => page_id )
        #redirect_to p_pu_path(@topic.id, 1) and return
      #end

      @temp_topics = Topic.where("section_id = ? and id < ?", @topic.section_id, @topic.id).order("id DESC").limit(10)

#获取当前页前后有文章的页
#@temp_pages = PageUrl.where("topic_id = ? and (status = 0 or count > 0)", @topic.id).limit(11)
#@temp_pages = PageUrl.where("topic_id = ? and (status = 0 or count > 0) and num > ?",  @topic.id, (page_id.to_i - 5)).limit(11)

    end

    #for seo
    #@fun = Fun.

  end
end
