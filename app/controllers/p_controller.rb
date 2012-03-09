#encoding: utf-8
class PController < ApplicationController

  def show
    column = params[:id].split(/_/)
    current_topic = column[0] if !column[0].blank?
    current_page  = column[1] if !column[1].blank?
    current_page ||= 1
    current_topic ||= 1

    @topic = Topic.find_by_id(current_topic)
    if @topic.blank?
      redirect_to all_path,notice:"对不起，打开出错，可能文章不存在或已经被删除！"
      return
    else

    end
  end

  def index
    @topic = Topic.page(params[:page])
  end

end
