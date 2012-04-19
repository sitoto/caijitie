#encoding: utf-8
class PvController < ApplicationController
  layout 'april'
  def index
      p_id = params[:p_id]
      page_id = params[:page]
      @topic = Topic.find(p_id)
      @page_urls = PageUrl.select("id").where("topic_id = ?  and status = 1 and count > 0 ", @topic.id)
      #page_url_ids = []
      page_url_ids = @page_urls.collect { |p| p.id }.join(',')


      if @topic.section_id.eql?(1)
        #@posts = TiebaPost.where("page_url_id in  (#{page_url_ids.to_sentence(:two_words_connector => ',', :last_word_connector => ',')})").order("page_url_id").page(page_id)
        @posts = TiebaPost.where("page_url_id in  (#{page_url_ids})").order("page_url_id").page(page_id)
        #@posts = TiebaPost.find_all_by_page_url_id(page_url_ids, :order => "page_url_id").page(page_id)
        #@posts = PageUrl.find_by_topic_id(p_id).tieba_posts.page(page_id)
      elsif @topic.section_id.eql?(2)
        @posts = TianyaPost.where("page_url_id in  (#{page_url_ids})").order("page_url_id").page(page_id)
      elsif @topic.section_id.eql?(3)
        @posts = DoubanPost.where("page_url_id in  (#{page_url_ids})").order("page_url_id").page(page_id)
      end

      @temp_topics = Topic.where("section_id = ?", @topic.section_id).order("id DESC").limit(10)

    #for seo
    breadcrumb :list, "贴吧" if @topic.section_id == 1
    breadcrumb :list, "天涯论坛" if @topic.section_id == 2
    breadcrumb :list, "豆瓣小组" if @topic.section_id == 3

    meta :title => @topic.title.strip ,
         :description => "#{ @topic.title}_脱水版本,作者:#{ @topic.author},第#{params[:page]}页,摘要：#{@posts.first.content.strip.truncate(255)}" ,
         :keywords => @topic.author
  end

end
