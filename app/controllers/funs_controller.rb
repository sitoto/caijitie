#encoding: utf-8
class FunsController < ApplicationController
  caches_page :show
  def index
    @funs = Fun.order('id DESC').page(params[:page])

    #for seo
    breadcrumb :fun_list, '笑话'
    meta :title => '笑话幽默' ,
         :description => "站内笑话，乐哈子" ,
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
    breadcrumb :fun_detail, @fun
    meta :title =>  @fun.title ,
         :description => @fun.body.truncate(100),
         :keywords => @fun.title
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fun }
    end
  end

end
