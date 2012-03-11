#encoding: utf-8
require 'get_tieba_page_url'
class PController < ApplicationController
  include GetTiebaPageUrl

  def show
    current_topic = params[:id]
    @topic = Topic.find_by_id(current_topic)
    if @topic.blank?
      flash[:notice] = "对不起，打开出错，可能文章不存在或已经被删除！"
    else
      @tieba_posts = TiebaPost.find_by_sql(["select  a.* from  tieba_posts a
                        LEFT JOIN page_urls b on a.page_url_id = b.id
                        WHERE b.num = 1 and b.topic_id = ? LIMIT 2;", current_topic])
    end
    breadcrumb :tb_detail, @topic
    meta :title => @topic.title, :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"

  end

  def index
    @topic = Topic.page(params[:page])
  end

  def renew
    current_topic = params[:id]
    @topic = Topic.find_by_id(current_topic)
    if (@topic.section_id.eql?(1))
      t = TiebaTuoshuiJob.update_topic(@topic)
    elsif (@topic.section_id.eql?(2))
      #ty
    elsif (@topic.section_id.eql?(3))
      #douban
    end
    puts "====================="
    update_topic(t)
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

end
