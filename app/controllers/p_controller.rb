#encoding: utf-8
class PController < ApplicationController

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
    breadcrumb :tb_list, @topics
    meta :title => "热贴列表", :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"

  end

  def index
    @topic = Topic.page(params[:page])
  end

end
