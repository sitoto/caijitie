#encoding: UTF-8
class TbController < ApplicationController
  caches_page :index


  def index
    @topics = Topic.where("section_id = 1").order("id DESC").page(params[:page])
    #for seo
    breadcrumb :tb_list, @topics
    meta :title => "热贴列表", :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"
  end


  def show
  end

end
