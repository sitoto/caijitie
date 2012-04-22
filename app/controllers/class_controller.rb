#encoding: utf-8
class ClassController < ApplicationController
  caches_page :index

  def index
    @classes = Topic.find_by_sql("SELECT count(*) as count , classname  FROM `topics` GROUP BY classname  ORDER BY count DESC limit 40")
    @authores = Topic.find_by_sql("SELECT count(*) as count, author  FROM `topics` GROUP BY author  ORDER BY count DESC limit 40")
    breadcrumb :list, '分类'
    meta :title => "分类", :description => "脱水文章分类" , :keywords => "文章,分类"
  end

end
