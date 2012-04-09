#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class Admin::TopicListController < ApplicationController
  layout "admin"
  def index
  end

  def tieba
  end

  def tianya
   type_id = params[:id]
    types = [ 'http://www.tianya.cn/publicforum/articleslist/0/funinfo.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/feeling.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/free.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no04.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/worldlook.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/develop.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no11.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/filmtv.shtml',
'http://www.tianya.cn/techforum/articleslist/0/665.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/stocks.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no05.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/motss.shtml',
'http://www.tianya.cn/techforum/articleslist/0/14.shtml',
'http://www.tianya.cn/techforum/articleslist/0/96.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/culture.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/travel.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/house.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/fans.shtml',
'http://www.tianya.cn/techforum/articleslist/0/98.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/basketball.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/fansunion.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/cars.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/tianyamyself.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/enterprise.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/news.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/itinfo.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/numtechnoloy.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no20.shtml',
'http://www.tianya.cn/techforum/articleslist/0/100.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/university.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/lookout.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/it.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no01.shtml',
'http://www.tianya.cn/techforum/articleslist/0/685.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no17.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/tianyaphoto.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/play.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/music.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/law.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/outseachina.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/books.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/water.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/female.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no22.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no16.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/spirit.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/poem.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/169.shtml',
'http://www.tianya.cn/publicforum/articleslist/0/no06.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/no110.shtml']
    tianya_url(types[type_id.to_i])
  end

  def douban
  end

  private
  def tianya_url(url)
   html_stream  = open(url)
    regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\/[0-9]+\/[0-9]+\.shtml/
    doc = Nokogiri::HTML(html_stream)
   @tianya_title = doc.css("title").text
    @tianya = []
   if(doc.at_css("div#mainDiv > div#forumContentDiv > table"))
    doc.css("div#mainDiv > div#forumContentDiv > table").each do |item|
      if item.attr("name") == "adsp_list_post_info_a" || item.attr("name") == "adsp_list_post_info_b"
        @tianya << [item.css("td")[1].text, item.css("td")[2].text, item.css("td")[3].text,
                    item.css("td")[4].text, item.css("td")[5].text, item.at_css("a").attr("href")]
      end
    end
   elsif (doc.css("div#postlistwrapper > table.listtable"))
      doc.css("div#postlistwrapper > table.listtable").each do |item|
         if item.attr("name") == "adsp_list_post_info_a" || item.attr("name") == "adsp_list_post_info_b"
            @tianya <<  [item.css("td")[0].text, item.css("td")[1].text, item.css("td")[2].text, item.css("td")[3].text,
                        item.css("td")[4].text,  item.at_css("a").attr("href")]
         end

      end

   end
  rescue
    return ''
  end

end
