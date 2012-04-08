#encoding: utf-8
class FunsController < ApplicationController
  caches_page :show
  def index
    @funs = Fun.order('id DESC').page(params[:page])

    #for seo
    breadcrumb :fun_list, '笑话'
    meta :title => '短文笑话' ,
         :description => "站内笑话，短文，名言，古文，乐哈子" ,
         :keywords => '笑话，短文，名言，古文，乐哈子'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @funs }
    end
  end

  # GET /funs/1
  # GET /funs/1.json
  def show
    a = Integer(params[:id]) -1
    b = Integer(params[:id]) +1
    @fun =Fun.find(params[:id])
    @fun_p =Fun.find_by_sql("select id, title from funs where id = #{a}").first
    @fun_n =Fun.find_by_sql("select id, title from funs where id = #{b}").first

    @fun.increment!(:click_time, by = 1)
    arr = get_random_numbers(Fun.count,18)
   # @relation_funs = Fun.find_by_sql("select id, title from funs where id in (#{arr})");
    @relation_funs = Fun.find(arr, :select => "id, title")
    breadcrumb :fun_detail, @fun
    meta :title =>  @fun.title ,
         :description => ActionController::Base.helpers.strip_tags(@fun.body).truncate(80),
         :keywords => @fun.title
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fun }
    end
  end

  def get_random_numbers  count,max
   (1..count).to_a.sample(max)
  end
end
