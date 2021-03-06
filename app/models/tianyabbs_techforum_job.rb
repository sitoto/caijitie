#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class TianyabbsTechforumJob
  def self.cai_tianyabbs_topic(url)
    #判断是否可以访问该网址
    begin
      html_stream  = open(url)
    rescue OpenURI::HTTPError => ex
      puts " can't get url: #{url}"
      return  ""
    end
    doc = Nokogiri::HTML(html_stream)
    is_pagnation(doc)? i = 0 : i = 1 #有多页
    get_tianya_topic(url,doc, i)
  end
  def self.update_topic(topic)
    cai_tianyabbs_topic(topic.fromurl)
  end
  def self.get_tianyabbs_post(topic, page_url)
    begin
      html_stream  = open(page_url.url)
    rescue #OpenURI::HTTPError => ex
      puts " can't get url: #{page_url.url}"
      return ''
    end
    doc = Nokogiri::HTML(html_stream)
    t =  filter_tianyabbs_post(doc, topic.author,page_url.id, topic.status)
  end
  def self.filter_tianyabbs_post(doc, lz, url_id, s = 0)

    i = 0
    j = 0
    doc.css("div#pContentDiv > div.item").each do |item|

			author = item.at_css("div.vcard a").text
      level = item.at_css("div.vcard span.floor").text
			created_at = chk_datetime item.at_css("div.vcard").text.last(19)
      if item.at_css("div.post")
        content =  item.at_css("div.post").inner_html
        content = content.gsub(/\<span.+/, '')
        content = content.gsub(/\<div.+/, '')
		content = content.gsub(/\<input.*/, '')
        content = content.gsub(/\<center.+/, '')
        content = content.gsub(/\<h.+/, '')
        content = content.gsub(/\<p.+/, '')
        content = content.gsub(/\<iframe.+/, '')
      else
         content = ''
      end

      if  s == 0
         if author == lz
           i += 1
           TianyaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => i ,:author => lz)
         end
      elsif s == 1
        j += 1
        TianyaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => j ,:author => lz)
      end
    end # end -do each
    return  i

   # rescue
   #   return -1

  end

  def self.is_pagnation(doc)
    if !doc.at_css("#pageDivTop em").blank? || !doc.at_css("#cttPageDiv em").blank?
      return true
    else
      return false
    end
  end

  def self.get_tianya_topic(url, doc, i = 0) # 0表示多页
    page_urls = []
    if (i != 0)
      #只有一页
      t = get_topic_from_first_page(url, doc, 1)
      page_urls = [url]
    else
      #多页
      t = ty_topic_muli_page(url, doc)
      page_urls = [url]
    end
    [t, page_urls]
  end

  def self.get_topic_from_first_page(url, doc, page_num = 1 )
    title = doc.at_css("h1 span a").parent.text.from(6)
    category = doc.at_css("h1 span a").text

    if doc.at_css(".pagewrap table td a")
      lz = doc.at_css(".pagewrap table td a").text
      str_created_at = doc.at_css(".pagewrap table td").text.last(19)
      str_post_info = doc.at_css(".pagewrap .function .info").text
    elsif doc.at_css("div#pContentDiv > div.item > div.vcard > a")
      lz = doc.at_css("div#pContentDiv > div.item > div.vcard > a").text
      str_created_at = doc.at_css("div#pContentDiv > div.item > div.vcard").text.last(19)
      str_post_info = doc.at_css("div#content-container .post-bar .info").text
    end


		created_at = chk_datetime str_created_at
    all_post_num = str_post_info.split('：')[2]
    fromurl = url
    all_page_num =  1
    #获取总页数
    if(page_num != 1)
      if doc.at_css("#pageDivTop span")
        str_page_info = doc.at_css("#pageDivTop span").text
      elsif doc.at_css("div#cttPageDiv")
        str_page_info = doc.at_css("div#cttPageDiv span").text
      end

      regEx_num = /\d+/
      if regEx_num  =~ str_page_info
        all_page_num = regEx_num.match(str_page_info).to_s
      end
    end


    t = {:title => title, :classname => category, :author => lz,
                  :firsttime => created_at,  :myupdatetime => Time.now,
                  :mypagenum => all_page_num, :mypostnum => all_post_num,
                  :tags => title , :fromurl => fromurl, :section_id => 2, :rule => 4}
  end

  def self.ty_topic_muli_page(url, doc)
    cpn = doc.at_css("#cttPageDiv em").content
    #非第一页-> 获取第一页 url 和 doc
    unless cpn.eql?('1')
      url = doc.at_css("#cttPageDiv a").attr("href")
      puts "current page is not 1"
      html_stream = get_html_stream(url)
      if html_stream.blank?
        return
      end
      doc = Nokogiri::HTML(html_stream)
    end
    t = get_topic_from_first_page(url, doc, 9)
  end

  #common method
  def self.chk_datetime str
    regEx = /2\d+-[0-9]+-[0-9]+\D[0-9]+:\d+:\d+/
    if regEx =~ str
      return regEx.match(str).to_s
    end
    return "0000-00-00 0:0:0"
  end
end