#encoding: UTF-8
class TysqsController < ApplicationController
  caches_page :show

  def show
    @topics = Topic.where("section_id = 2").order("id DESC").page(params[:page])
  end

end
