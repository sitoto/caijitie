#encoding: UTF-8
class TbController < ApplicationController
  def index
    @topics = Topic.order("mypostnum DESC").page(params[:page])
    #for seo    .where("section_id = 1")
    breadcrumb :tb_list, @topics
    meta :title => "热贴列表", :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"
  end

  def hot
  end

  def recent
  end

  def active
  end

  def renew
  end

  def show
  end

end
