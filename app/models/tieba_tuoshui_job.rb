#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class TiebaTuoshuiJob
  def self.cai_tieba(url)
    #判断是否可以访问该网址
    begin
      html_stream  = open(url)
    rescue OpenURI::HTTPError => ex
      puts " can't get url: #{url}"
      return  ""
    end
    doc = Nokogiri::HTML(html_stream)
    is_pagnation(doc)? i = 0 : i = 1 #有多页
    get_tieba_topic(doc, i)
  end

  def self.update_topic topic
    cai_tieba(topic.fromurl)
  end
  def self.get_tieba_post(topic, page_url)
     begin
      html_stream  = open(page_url.url)
    rescue #OpenURI::HTTPError => ex
      puts " can't get url: #{page_url.url}"
      return ''
    end
    doc = Nokogiri::HTML(html_stream)
    t =  filter_tieba_post(doc, topic.author,page_url.id, topic.status)
  end
  def self.filter_tieba_post(doc, lz, url_id, s = 0)
    i = 0
    j = 0
    doc.css(".p_postlist .l_post").each do |item|
      post_json_str = item.css(".p_post").attr("data-field")
      json_post = JSON.parse(post_json_str)
      created_at = json_post["content"]["date"]
      author = json_post["author"]["name"]
      level = json_post["content"]["floor"]
      content =  item.css(".d_post_content").inner_html

      if  s == 0
         if author == lz
           i += 1
           TiebaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => i ,:author => lz)
         end

      elsif s == 1
        j += 1
        TiebaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => j ,:author => lz)

      end
    end
      return  1
    rescue
      return 0
  end
  def self.is_pagnation(doc)
    if doc.at_css(".p_thread .l_thread_info .l_posts_num .l_pager").blank?
      return false
    else
      return true
    end
  end

  def self.get_tieba_topic(doc, i = 0) # 0表示多页
    if doc.at_css(".p_thread .l_thread_info .l_posts_num li span").blank?   #不是贴子页面
      return
    end
    all_post_num = doc.at_css(".p_thread .l_thread_info .l_posts_num li span.d_red_num").text
    title = doc.at_css("h1").text
    if doc.at_css("a#pb_nav_main").blank?
      category = doc.at_css("cb").text
    else
      category = doc.at_css("a#pb_nav_main").text
    end
      post_json_str= doc.at_css(".l_post .p_post").attr("data-field")
		  json_post = JSON.parse(post_json_str)
    created_at = json_post["content"]["date"]
    lz = json_post["author"]["name"]
    all_page_num = 1
    if (i == 0) #get pagelist
      doc.css(".p_thread .l_thread_info .l_posts_num .l_pager a").each do |link|
          if link.text == "尾页"
            str = link.attr("href")
            column = str.split(/=/)
            all_page_num = column[1]
            break
          end
      end
    end
    t = {:title => title, :classname => category, :author => lz,
                  :firsttime => created_at,  :myupdatetime => Time.now,
                  :mypagenum => all_page_num, :mypostnum => all_post_num,
                  :tags => title , :section_id => 1}
  end




end