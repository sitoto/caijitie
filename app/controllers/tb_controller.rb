#encoding: UTF-8
class TbController < ApplicationController
  def index
    per_page = 25
    @topics = Topic.where("section_id = 0").order("mypostnum DESC").page(params[:page]).per(per_page)
    @class_name ='/tb/hot'

    breadcrumb :tb, @topics
    meta :title => "热贴列表", :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"
  end

  def hot
  end

  def recent
  end

  def active
  end

  def category
  end

  def author
  end

  def tag
  end

  def renew
  end

  def show
  end

end
