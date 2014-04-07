#encoding: utf-8
class RecentsController < ApplicationController
#  caches_page :index
  caches_page :show

  def show 
    @topics = Topic.order("created_at DESC").page(params[:page])
  end

end
