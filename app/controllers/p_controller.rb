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
    if (@topic.section_id.eql?(1))
      t = TiebaTuoshuiJob.update_topic(@topic)
      update_topic(t)
    elsif (@topic.section_id.eql?(2))
      t, page_urls = TianyabbsTuoshuiJob.update_topic(@topic)
      update_tianyabbs_topic(t, page_urls)
    elsif (@topic.section_id.eql?(3))
      #douban
      t = DoubanhuatiTuoshuiJob.update_topic(@topic)
      update_douban_topic(t)
    end
    puts "====================="

    redirect_to p_path(@topic), :notice => "已提交更新。"

  #rescue
  #  redirect_to root_path :notice => "error。"
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
     unless t.blank?
        @topic.update_attributes(t)
        if @topic.save
           max_page_url = @topic.most_recent_page_url
           max = max_page_url.num || 0
           max_page_url.destroy
           if page_urls.length == 1
             if max == 0
               PageUrl.create!(:topic_id => @topic.id, :num => 1, :url => page_urls[0],
                               :status => 0, :count => 1)
             end
           elsif page_urls.length > 1
             page_urls.to_a.each_with_index  do |p, i|
              if i >= max
                 PageUrl.create!(:topic_id => @topic.id, :num => i+1, :url => get_tianya_page_url(@topic.fromurl, p),
                                 :status => 0, :count => 1)
              end
             end
          end
        end
        redirect_to p_path(@topic)
        return
     end
  end

end
