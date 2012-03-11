#encoding: utf-8
require 'get_tieba_page_url'
class SearchController < ApplicationController
  include GetTiebaPageUrl

  def index
    per_page = 20
    search_text = params[:q]
    search_text ||= ""
    puts search_text
    s_id = is_url?(search_text)
    puts s_id

    if s_id == 0
      @search = Post.where("title like ?", "%" << search_text << "%").order('published_at DESC').page(params[:page]).per(per_page)
      #for seo
      breadcrumb :search, search_text
      meta :title => "搜索：#{search_text}", :description => "搜索：#{search_text}的结果" , :keywords => search_text
      return
    elsif t = PageUrl.find_by_sql(["select * from page_urls where url = ? ", search_text]).first
      redirect_to p_path(t.topic_id)
      return
      #存在url
    else
      @topic = Topic.new()
      case s_id
        when 1
          t = @topic.get_tieba_topic(@url)
        when 2
          t = @topic.get_tieba_topic(@url)
        when 3
          @topic.get_tianya_topic(@url)
        when 4
          @topic.get_douban_topic(@url)
        end
      update_topic(t)
    end
  end

  protected
  def update_topic(t)
     unless t.blank?
        t[:fromurl] = @url
        @topic.update_attributes(t)
        if @topic.save
           max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
           max = 1 if max == 0
           max.upto(@topic.mypagenum)  do |a|
            PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tieba_page_url(@topic.fromurl,a),
                               :status => 0, :count => 1)
          end
        end
        redirect_to p_path(@topic)
        return
     end
  end

  def is_url?(url)
     regEx_tieba_1 = /baidu\.com\/p\/[0-9]*/
     regEx_tieba_2 = /baidu\.com\/f\?kz\=[0-9]*/
     regEx_tieba_2_1 = /[0-9]*/
     regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\/[0-9]+\/[0-9]+\.shtml/
     regEx_douban_1 = /douban\.com\/group\/topic\/[0-9]*/

      if regEx_tieba_1  =~ url
        sid = 1
        @url = ("http://tieba." << regEx_tieba_1.match(url).to_s)
      elsif regEx_tieba_2  =~ url
        sid = 1
         @url = ("http://tieba.baidu.com/p/" << regEx_tieba_2_1.match(url).to_s)
      elsif regEx_tianya_1 =~ url
        sid = 2
        @url ="http://www." << regEx_tianya_1.match(url).to_s
      elsif regEx_douban_1 =~ url
        sid = 3
        @url = ("http://www." << regEx_douban_1.match(url).to_s << "/")
      end

    sid
  end


end
