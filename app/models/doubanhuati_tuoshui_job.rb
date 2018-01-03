#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'common'
class DoubanhuatiTuoshuiJob
  include Common
  def self.strip_emoji(text)
    text = text.force_encoding('utf-8').encode
    clean = ""

    # symbols & pics
    regex = /[\u{1f300}-\u{1f5ff}]/
    clean = text.gsub regex, ""

    # enclosed chars 
    regex = /[\u{2500}-\u{2BEF}]/ # I changed this to exclude chinese char
    clean = clean.gsub regex, ""

    # emoticons
    regex = /[\u{1f600}-\u{1f64f}]/
    clean = clean.gsub regex, ""

    #dingbats
    regex = /[\u{2702}-\u{27b0}]/
    clean = clean.gsub regex, ""
  end


  def self.cai_doubanhuati_topic(url, s = 0)
    #判断是否可以访问该网址
    begin
      html_stream  = open(url)
    rescue OpenURI::HTTPError => ex
      puts " can't get url: #{url}"
      return  ""
    end
    doc = Nokogiri::HTML(html_stream)
    is_pagnation(doc)? i = 0 : i = 1 #有多页
    get_doubanhuati_topic(doc, i, s)

  end
  def self.update_topic topic
    cai_doubanhuati_topic(topic.fromurl)
  end

  def self.get_doubanhuati_post(topic, page_url)
    begin
      html_stream  = open(page_url.url)
    rescue #OpenURI::HTTPError => ex
      puts " can't get url: #{page_url.url}"
      return ''
    end
    doc = Nokogiri::HTML(html_stream)
    t =  filter_doubaihuati_post(doc, topic.author,page_url.id, topic.status)
  end
  def self.filter_doubaihuati_post(doc, lz, url_id, s = 0)
    i = 0
    j = 0
    unless doc.at_css("div.topic-doc > h3 > span.color-green").blank?
      created_at = doc.at_css("div.topic-doc > h3 > span.color-green").text
      #firstcontent = doc.at_css("div.topic-doc > div.topic-content > p").inner_html
      firstcontent = doc.at_css("div.topic-doc  div.topic-content").inner_html
      puts firstcontent = strip_emoji(firstcontent)
      j = j+1
      DoubanPost.create!(:page_url_id => url_id, :content => firstcontent, :post_at => created_at,
                         :level  => 0, :my_level => j ,:author => lz)
    end
    doc.css(".reply-doc").each_with_index do |item, i|
      author = item.at_css("a").text
      created_at  = item.at_css("h4").text
      content= item.at_css("p").inner_html


      if item.at_css("div.reply-quote").blank?                                                                                                                                                          
        content =  item.at_css("p").inner_html.to_s.strip_href_tag

      else
        replay_content = item.at_css("div.reply-quote > span.all").inner_html.to_s.strip_href_tag
        replay_author = item.at_css("div.reply-quote > span.pubdate").inner_html.to_s.strip_href_tag
        content = "<pre>#{replay_content} (#{replay_author})</pre> #{ item.at_css("p").inner_html.to_s.strip_href_tag}"

      end

      content = strip_emoji(content)



      if (s == 0 && author == lz)
        #@temp_posts[i] = [i,created_time,content,j+1]
        j += 1
        DoubanPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                           :level  => i, :my_level => j ,:author => author)
      elsif s == 1
        j += 1
        DoubanPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                           :level  => i, :my_level => j ,:author => author)
      end
    end
    return  j
  rescue
    puts "error XXXXXXXXXXXXXXXXXXXXXXXXXXXX douban tuoshui"
    return -1
  end


  def self.is_pagnation(doc)
    if doc.at_css("div.paginator").blank?
      return false
    else
      return true
    end
  end

  def self.get_doubanhuati_topic(doc, i = 0, s = 0) # 0表示多页
    title = doc.at_css("title").text.strip

    if doc.at_css("div.topic-doc > table.infobox .tablecc")
      title =  doc.at_css("div.topic-doc > table.infobox .tablecc").text.from(3)
    end

    category = "豆瓣小组" #doc.at_css("div.info > div.title > a").text
    lz = doc.at_css("div.topic-doc > h3 > span > a").text
    created_at = doc.at_css("div.topic-doc > h3 > span.color-green").text
    #fromurl = url    #存入首页地址
    all_page_num =  1
    if i==0
      #获取总页数
      doc.css("div.paginator > a").each do |link|
        all_page_num = link.text
      end
    end
    all_post_num = all_page_num.to_i * 100

    t = {:title => title, :classname => category, :author => lz,
      :firsttime => created_at,  :myupdatetime => Time.now,
      :mypagenum => all_page_num, :mypostnum => all_post_num,
      :tags => title ,  :section_id => 3,  :rule => 3, :status => s}

  end
end
