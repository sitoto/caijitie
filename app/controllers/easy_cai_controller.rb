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
    if (@easy_cai && @easy_cai.section_id == 2)
      tianya_url(@easy_cai.url_address)
    elsif (@easy_cai && @easy_cai.section_id == 1)
      tieba_url(@easy_cai.url_address)
    elsif (@easy_cai && @easy_cai.section_id == 3)
      douban_url(@easy_cai.url_address)
    end

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

  def tieba_url(url)
    html_stream  = open(url)
    doc = Nokogiri::HTML(html_stream)
    @bankuai_title = doc.css("title").text
    @bankuai = []

    if(doc.at_css("ul#thread_list"))
      doc.css("ul#thread_list > li").each do |item|
        @bankuai << [item.at_css("div.th_w2 > div.th_lz").text.strip,
                      item.at_css("div.th_w2 > span.th_author").text,
                      0,
                      item.at_css("div.th_w1 > div").text.strip,
                      item.at_css("div.th_w2 > span.th_reply_data").text,
                      "http://tieba.baidu.com" << item.at_css("div.th_w2 > div.th_lz > a").attr("href")
                      ]
      end

    elsif (doc.at_css("div#thread_list > table"))
      doc.css("table#thread_list_table > tbody > tr").each do |item|
        @bankuai << [item.css("td")[2].text.strip, item.css("td")[3].text, item.css("td")[0].text,
                    item.css("td")[1].text.strip, item.css("td")[4].text,
                    "http://tieba.baidu.com" << item.at_css("a").attr("href")]
      end

    end
      rescue
    return ''
  end

  def douban_url(url)
    html_stream  = open(url)
    doc = Nokogiri::HTML(html_stream)
    @bankuai_title = doc.css("title").text
    @bankuai = []
    doc.css("div#content  div.article > table  > tr").each_with_index do |item, i|
      if i > 0
         @bankuai <<  [ item.css("td")[0].text,
                        item.css("td")[1].text,
                        0,
                        item.css("td")[2].text,
                        item.css("td")[3].text,
                        item.at_css("td > a").attr("href")]
      end

    end
  end

end
