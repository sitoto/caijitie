#encoding: utf-8
class ActivesController < ApplicationController
  caches_page :show

  def show
    @topics = Topic.order("myupdatetime DESC").page(params[:page])
  end

end
