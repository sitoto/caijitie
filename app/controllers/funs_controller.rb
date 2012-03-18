#encoding: utf-8
class FunsController < ApplicationController
  #caches_page :show
  def index
    @funs = Fun.order('id DESC').page(params[:page])

    #for seo
    breadcrumb :list, '笑话'
    meta :title => '笑话列表' ,
         :description => "笑话列表" ,
         :keywords => '笑话'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @funs }
    end
  end

  # GET /funs/1
  # GET /funs/1.json
  def show
    @fun = Fun.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fun }
    end
  end

end
