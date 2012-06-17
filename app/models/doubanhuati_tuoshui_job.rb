#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class DoubanhuatiTuoshuiJob
  def self.cai_doubanhuati_topic(url, s)
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
      firstcontent = doc.at_css("div.topic-doc > div.topic-content").inner_html
      j = j+1
      DoubanPost.create!(:page_url_id => url_id, :content => firstcontent, :post_at => created_at,
                    :level  => 0, :my_level => j ,:author => lz)
    end
    doc.css(".reply-doc").each_with_index do |item, i|
      author = item.at_css("a").text
      created_at  = item.at_css("h4").text
			content= item.at_css("p").inner_html
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
    title = doc.at_css("title").text

    if doc.at_css("div.topic-doc > table.infobox .tablecc")
      title =  doc.at_css("div.topic-doc > table.infobox .tablecc").text.from(3)
    end

    category = doc.at_css("div.aside > p > a").text.from(1)
    lz = doc.at_css("div.topic-doc > h3 > span.pl20 > a").text
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