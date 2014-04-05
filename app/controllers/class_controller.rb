#encoding: utf-8
class ClassController < ApplicationController
  caches_page :index

  def index
    @classes = Topic.find_by_sql("SELECT distinct(classname)  FROM `topics` ")
    @authores = Topic.find_by_sql("SELECT distinct(author)  FROM `topics`")
    breadcrumb :list, '分类'
    meta :title => "分类", :description => "文章分类，作者分类" , :keywords => "文章,分类"
  end

end
