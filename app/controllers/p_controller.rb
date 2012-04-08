#encoding: utf-8
require 'get_tieba_page_url'
class PController < ApplicationController
  include GetTiebaPageUrl

  def show
    current_topic = params[:id].to_i
    @topic = Topic.find_by_id(current_topic)
    if @topic.blank?
      flash[:notice] = "对不起，打开出错，可能文章不存在或已经被删除！"
    else
      @page_urls =PageUrl.where("topic_id = ?", @topic.id).page(params[:page]).per(500) #@topic.page_urls

#      @posts = TiebaPost.find_by_sql(["select  a.* from  tieba_posts a
#                        LEFT JOIN page_urls b on a.page_url_id = b.id
#                        WHERE b.num = 1 and b.topic_id = ? LIMIT 2;", current_topic]) if @topic.section_id == 1
#
#      @posts = TianyaPost.find_by_sql(["select  a.* from  tianya_posts a
#                        LEFT JOIN page_urls b on a.page_url_id = b.id
#                        WHERE b.num = 1 and b.topic_id = ? LIMIT 2;", current_topic]) if @topic.section_id == 2
    end
    breadcrumb :tb_detail, @topic  if @topic.section_id == 1
    breadcrumb :tysq_detail, @topic  if @topic.section_id == 2
    breadcrumb :dbht_detail, @topic  if @topic.section_id == 3

    meta :title => @topic.title, :description => "热贴列表" , :keywords => "贴子,脱水"

  end

  def index
    @topic = Topic.page(params[:page])
  end

  def renew
    current_topic = params[:id]
    @topic = Topic.find_by_id(current_topic)
    if (@topic.rule.eql?(1))
      t = TiebaTuoshuiJob.update_topic(@topic)
      update_topic(t)
    elsif (@topic.rule.eql?(2))
      t, page_urls = TianyabbsTuoshuiJob.update_topic(@topic)
      update_tianyabbs_topic(t, page_urls)
    elsif (@topic.rule.eql?(4))
      t, page_urls = TianyabbsTechforumJob.update_topic(@topic)
      update_tianyabbs_techfroum_topic(t)
    elsif (@topic.rule.eql?(3))
      #douban
      t = DoubanhuatiTuoshuiJob.update_topic(@topic)
      update_douban_topic(t)
    end
    puts "====================="

    redirect_to p_pu_path(@topic, 1), :notice => "已提交更新。"

 # rescue
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
            PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tieba_page_url(@topic.fromurl,a),
                               :status => 0, :count => 1)
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
            PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_doubanhuati_page_url(@topic.fromurl,(a-1) * 100),
                               :status => 0, :count => 1)
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
               PageUrl.create!(:topic_id => @topic.id, :num => 1, :url => page_urls.to_a[0],
                               :status => 0, :count => 1)
             end
           elsif page_urls.to_a.length > 1
             page_urls.to_a.each_with_index  do |p, i|
              if (i + 1) >= max
                 PageUrl.create!(:topic_id => @topic.id, :num => (i + 1), :url => get_tianya_page_url(@topic.fromurl, p),
                                 :status => 0, :count => 1)
              end
             end
          end
        end
     end
  end
  def update_tianyabbs_techfroum_topic(t)
    unless t.blank?
       t[:fromurl] = @url
        @topic.update_attributes(t)
        if @topic.save
           max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
           max = 1 if max == 0
           max.upto(@topic.mypagenum)  do |a|
            PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tianya_techfroum_page_url(@topic.fromurl, a),
                               :status => 0, :count => 1)
          end
        end
        redirect_to p_path(@topic)
        return
     end
  end
end
