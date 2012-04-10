#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class EasyCaiController < ApplicationController
  layout "easycai"
  def index
    @easy_cais = EasyCai.order('paixu').page(params[:page])
  end

  def show
    type_id = params[:id]
    @easy_cai = EasyCai.find_by_id(type_id)
    tianya_url(@easy_cai.url_address) if @easy_cai
  end

  private
  def tianya_url(url)
   html_stream  = open(url)
    regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\/[0-9]+\/[0-9]+\.shtml/
    doc = Nokogiri::HTML(html_stream)
   @bankuai_title = doc.css("title").text
    @bankuai = []
   if(doc.at_css("div#mainDiv > div#forumContentDiv > table"))
    doc.css("div#mainDiv > div#forumContentDiv > table").each do |item|
      if item.attr("name") == "adsp_list_post_info_a" || item.attr("name") == "adsp_list_post_info_b"
        @bankuai << [item.css("td")[1].text, item.css("td")[2].text, item.css("td")[3].text,
                    item.css("td")[4].text, item.css("td")[5].text, item.at_css("a").attr("href")]
      end
    end
   elsif (doc.css("div#postlistwrapper > table.listtable"))
      doc.css("div#postlistwrapper > table.listtable").each do |item|
         if item.attr("name") == "adsp_list_post_info_a" || item.attr("name") == "adsp_list_post_info_b"
            @bankuai <<  [item.css("td")[0].text, item.css("td")[1].text, item.css("td")[2].text, item.css("td")[3].text,
                        item.css("td")[4].text,  item.at_css("a").attr("href")]
         end

      end

   end
  rescue
    return ''
  end

end
