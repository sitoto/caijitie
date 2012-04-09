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
 'http://www.tianya.cn/publicforum/articleslist/0/no110.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/16.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/936.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/516.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/766.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/76.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/944.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/828.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/394.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/607.shtml',
 'http://www.tianya.cn/publicforum/articleslist/0/oldgirl.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/843.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/12.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/967.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/84.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/75.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/650.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/972.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/912.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/888.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/148.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/396.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/368.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/361.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/768.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/194.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/845.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/158.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/420.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/130.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/188.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/176.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/798.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/140.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/767.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/923.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/666.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/150.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/641.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/34.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/137.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/763.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/837.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/210.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/170.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/738.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/20.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/780.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/687.shtml',
 'http://www.tianya.cn/techforum/articleslist/0/395.shtml'    ]
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
