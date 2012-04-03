#encoding: utf-8
class DbhtController < ApplicationController
  def index
    @topics = Topic.where("section_id = 3").order("id DESC").page(params[:page])
    #for seo
    breadcrumb :dbht_list, @topics
    meta :title => "热贴列表", :description => "豆瓣话题热贴列表" , :keywords => "豆瓣话题,看豆贴,脱水"
  end
end
