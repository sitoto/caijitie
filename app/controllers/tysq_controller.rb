#encoding: UTF-8
class TysqController < ApplicationController
  def index
    @topics = Topic.where("section_id = 2").order("mypostnum DESC").page(params[:page])
    #for seo
    breadcrumb :tysq_list, @topics
    meta :title => "热贴列表", :description => "天涯社区热贴列表" , :keywords => "天涯社区,脱水"
  end

end