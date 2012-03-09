class PuController < ApplicationController
  def index
    if params[:p_id]
      @page_urls = PageUrl.where("topic_id = ?", params[:p_id]).page(params[:page])
    end
      #for seo
    #breadcrumb :tb, @topics
    #meta :title => "热贴列表", :description => "百度贴吧热贴列表" , :keywords => "贴吧,脱水"
  end
end
