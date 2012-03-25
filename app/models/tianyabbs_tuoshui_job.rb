#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class TianyabbsTuoshuiJob
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
  def self.filter_tianyabbs_post(doc, lz, url_id, s = 0)  #作者信息和内容信息 分开读取
    auth_time = {} # all auth info  作者信息
    author = doc.at_css(".pagewrap table td a").text
      created_at = doc.at_css(".pagewrap table td").text.last(19)
    created_at = chk_datetime created_at
    auth_time[0] = [author, created_at]
    tip = 1
    doc.css(".allpost > table").each do |item|
			author = item.at_css("center a").text
			time = chk_datetime item.at_css("center").text
			auth_time[tip] = [author, time]
      tip += 1
    end
    i = 0
    content_list = {} # 全部内容页   内容信息
    doc.css(".allpost .post").each do |item|
      if !item.blank?
        content =  item.inner_html
        content = content.gsub(/\<span.+/, '')
        content = content.gsub(/\<div.+/, '')
        content_list[i] = content
      else
         content_list[i] = ''
      end
      i += 1
    end
    #整理数据
    j = 0
    content_list.each_with_index do |i, value|
      if  s == 0
        if auth_time[value][0].eql?(lz)
          TianyaPost.create!(:content => i[1], :post_at => auth_time[value][1], :level => value + 1,
                           :page_url_id => url_id, :my_level => j+1 ,:author => lz)

          j += 1
        end
      else
        TianyaPost.create!(:content => i[1], :post_at => auth_time[value][1], :level => value + 1,
                           :page_url_id => url_id, :my_level => value + 1 ,:author => lz)
      end

    end
    return j
  rescue
    return -1
  end
  def self.is_pagnation(doc)
    if doc.at_css("#pageDivTop em").blank?
      return false
    else
      return true
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
      page_urls = doc.css("#pageDivTop input")[2].attr("value")
      page_urls = page_urls.split(',')
    end
    [t, page_urls]
  end

  def self.get_topic_from_first_page(url, doc, page_num = 1 )
    title = doc.at_css("h1 span a").parent.text.from(7)
    category = doc.at_css("h1 span a").text
    lz = doc.at_css(".pagewrap table td a").text
    str_created_at = doc.at_css(".pagewrap table td").text.last(19)
		created_at = chk_datetime str_created_at
      str_post_info = doc.at_css(".pagewrap .function .info").text
    all_post_num = str_post_info.split('：')[2]
    fromurl = url
    all_page_num =  1
    #获取总页数
    if(page_num != 1)
      str_page_info = doc.at_css("#pageDivTop span").text
      regEx_num = /\d+/
      if regEx_num  =~ str_page_info
        all_page_num = regEx_num.match(str_page_info).to_s
      end
    end


    t = {:title => title, :classname => category, :author => lz,
                  :firsttime => created_at,  :myupdatetime => Time.now,
                  :mypagenum => all_page_num, :mypostnum => all_post_num,
                  :tags => title , :fromurl => fromurl, :section_id => 2}
  end

  def self.ty_topic_muli_page(url, doc)
    cpn = doc.at_css("#pageDivTop em").content
    #非第一页-> 获取第一页 url 和 doc
    unless cpn.eql?('1')
      url = doc.at_css("#pageDivTop a").attr("href")
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