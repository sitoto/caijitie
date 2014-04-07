#encoding: utf-8
class CategoryController < ApplicationController
  def show
    @topics = Topic.where("classname = ?",params[:name]).order("id DESC").page(params[:page])
  end

end
