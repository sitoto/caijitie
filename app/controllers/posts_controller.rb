class PostsController < ApplicationController
  respond_to :html, :xml, :json, :atom
  layout 'blog'
  caches_page :index , :show

  def index
    per_page = params[:format] == 'atom' ? 25 : Post.per_page
    @tags = Tag.includes(:taggings).all
    @posts = Post.published.recent.page(params[:page]).per(per_page)
  end

  def show
    @tags = Tag.includes(:taggings).all
    @post = Post.where(permalink: params[:id]).first
  end
end
