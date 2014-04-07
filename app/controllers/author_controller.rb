#encoding: utf-8
class AuthorController < ApplicationController
  def show
    @topics = Topic.where("author = ?",params[:name]).order("id DESC").page(params[:page])
  end

end
