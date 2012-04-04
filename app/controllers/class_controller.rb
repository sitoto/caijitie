#encoding: utf-8
class ClassController < ApplicationController
  def index
    breadcrumb :list, '分类'
    meta :title => "分类", :description => "脱水文章分类" , :keywords => "文章,分类"
  end

end
