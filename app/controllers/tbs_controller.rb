#encoding: UTF-8
class TbsController < ApplicationController
  caches_page :show

  def show
    @topics = Topic.where("section_id = 1").order("id DESC").page(params[:page])
  end


end
