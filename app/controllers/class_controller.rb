#encoding: utf-8
class ClassController < ApplicationController
  caches_page :index

  def index
#    @classes = Topic.find_by_sql("SELECT distinct(classname)  FROM `topics` ")
    @classes = Topic.select('classname').uniq
    #@authores = Topic.find_by_sql("SELECT distinct(author)  FROM `topics`")
  end

end
