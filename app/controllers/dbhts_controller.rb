#encoding: utf-8
class DbhtsController < ApplicationController
  caches_page :show


  def show
    @topics = Topic.where("section_id = 3").order("id DESC").page(params[:page])
  end
end
