#encoding: utf-8
require 'get_tieba_page_url'
class PController < ApplicationController
  include GetTiebaPageUrl
  #caches_page :show

  def show
    current_topic = params[:id].to_i
    @topic = Topic.find_by_id(current_topic)
    if @topic.blank?
      flash[:notice] = "对不起，打开出错，可能文章不存在或已经被删除！"
      redirect_to root_path
    else
      @page_urls =PageUrl.where("topic_id = ? and (status = 0 or count > 0)", @topic.id).page(params[:page]).per(500) #@topic.page_urls

      #      @posts = TiebaPost.find_by_sql(["select  a.* from  tieba_posts a
      #                        LEFT JOIN page_urls b on a.page_url_id = b.id
      #                        WHERE b.num = 1 and b.topic_id = ? LIMIT 2;", current_topic]) if @topic.section_id == 1
      #
      #      @posts = TianyaPost.find_by_sql(["select  a.* from  tianya_posts a
      #                        LEFT JOIN page_urls b on a.page_url_id = b.id
      #                        WHERE b.num = 1 and b.topic_id = ? LIMIT 2;", current_topic]) if @topic.section_id == 2

    end

  end

  def index
    #@topic = Topic.page(params[:page])
  end

  def top
    p_id = params[:id].to_i
    @topic = Topic.find(p_id)
    @topic.increment!(:top, by = 1)
    expire2_cache
    #return @topic.top
    respond_to do |format|
      format.json { render :json => @topic.to_json}
    end
  end

  def renew
    current_topic = params[:id]
    @topic = Topic.find_by_id(current_topic)
    if @topic.blank?
      return
    end
    #last_page_num = PageUrl.count(:conditions => ["topic_id = ? and status = 1 and count > 0 ", @topic.id])
    all_page_num = PageUrl.count(:conditions => ["topic_id = ? ", @topic.id])
    1.upto(all_page_num) do |page|
      expire_page( :controller => "pu", :action => 'index' , :p_id => @topic.id, :page => page )
    end
    expire2_cache


    if (@topic.rule.eql?(1))
      t = TiebaTuoshuiJob.update_topic(@topic)
      update_topic(t)
    elsif (@topic.rule.eql?(2))
      t, page_urls = TianyabbsTuoshuiJob.update_topic(@topic)
      update_tianyabbs_topic(t, page_urls)
    elsif (@topic.rule.eql?(4))
      t, page_urls = TianyabbsTechforumJob.update_topic(@topic)
      update_tianyabbs_techfroum_topic(t)
    elsif (@topic.rule.eql?(5))
      t, page_urls = TianyabbsBbsJob.update_topic(@topic)
      update_tianyabbs_bbs_topic(t)
    elsif (@topic.rule.eql?(3))
      #douban
      t = DoubanhuatiTuoshuiJob.update_topic(@topic)
      update_douban_topic(t)
    end
    puts "====================="

    redirect_to p_path(@topic), :notice => "已提交更新。"

    #rescue
    #  redirect_to root_path :notice => "error"
  end


  protected
  def update_topic(t)
    unless t.blank?
      @topic.update_attributes(t)
      if @topic.save
        max_page_url = @topic.most_recent_page_url
        max = max_page_url.num || 1
        max_page_url.destroy
        max.upto(@topic.mypagenum)  do |a|
          @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tieba_page_url(@topic.fromurl,a),
                                      :status => 0, :count => 0)
          Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
        end
      end
    end
  end
  def update_douban_topic(t)
    unless t.blank?
      @topic.update_attributes(t)
      if @topic.save
        max_page_url = @topic.most_recent_page_url
        max = max_page_url.num || 1
        max = 1 if max_page_url.num == 0
        max_page_url.destroy

        max.upto(@topic.mypagenum)  do |a|
          @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_doubanhuati_page_url(@topic.fromurl,(a-1) * 100),
                                      :status => 0, :count => 0)
          Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
        end
      end
    end
  end
  def update_tianyabbs_topic(t, page_urls)
    #puts page_urls.to_a.length
    #puts "end"

    unless t.blank?
      @topic.update_attributes(t)
      if @topic.save
        max_page_url = @topic.most_recent_page_url
        max = max_page_url.num || 0
        max_page_url.destroy
        if page_urls.to_a.length == 1
          if max == 0
            @page_url = PageUrl.create!(:topic_id => @topic.id, :num => 1, :url => page_urls.to_a[0],
                                        :status => 0, :count => 0)
            Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
          end
        elsif page_urls.to_a.length > 1
          page_urls.to_a.each_with_index  do |p, i|
            if (i + 1) >= max
              @page_url = PageUrl.create!(:topic_id => @topic.id, :num => (i + 1), :url => get_tianya_page_url(@topic.fromurl, p),
                                          :status => 0, :count => 0)
              Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
            end
          end
        end
      end
    end
  end
  def update_tianyabbs_techfroum_topic(t)
    unless t.blank?
      @topic.update_attributes(t)
      if @topic.save
        #max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
        max_page_url = @topic.most_recent_page_url
        max = max_page_url.num || 0
        max_page_url.destroy
        max = 1 if max == 0
        max.upto(@topic.mypagenum)  do |a|
          @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tianya_techfroum_page_url(@topic.fromurl, a),
                                      :status => 0, :count => 0)
          Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
        end
      end
    end
  end
  def update_tianyabbs_bbs_topic(t)
    unless t.blank?
      @topic.update_attributes(t)
      if @topic.save
        max_page_url = @topic.most_recent_page_url
        max = max_page_url.num || 0
        max_page_url.destroy
        max = 1 if max == 0
        max.upto(@topic.mypagenum)  do |a|
          @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tianya_bbs_page_url(@topic.fromurl, a),
                                      :status => 0, :count => 0)
          Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
        end
      end
      #redirect_to p_path(@topic)
      #return
    end
  end
  private
  def expire2_cache
    # Expire the index page now that we added a new topic
    expire_page(:controller => 'pages', :action => 'home')
    expire_page(:controller => 'hot', :action => 'index')
    expire_page(:controller => 'actives', :action => 'show')

    # Expire a fragment
    expire_fragment('all_available_topics')
  end

end
