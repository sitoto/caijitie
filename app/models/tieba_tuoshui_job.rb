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
      html_stream  = open(page_url.url).read
      html_stream = html_stream.gsub("<!-- ", "")

      doc = Nokogiri::HTML(html_stream)
      t =  filter_tieba_post(doc, topic.author, page_url.id, topic.status)
    rescue #OpenURI::HTTPError => ex
      puts " can't get url: #{page_url.url}"
      return ''
    end
  end
  def self.filter_tieba_post(doc, lz, url_id, s = 0)
    i = 0
    j = 0
    puts     doc.css(".p_postlist .l_post").length

    doc.css(".p_postlist .l_post").each do |item|
      post_json_str = item.attr("data-field")
      json_post = JSON.parse(post_json_str)
      created_at = json_post["content"]["date"]
      author = json_post["author"]["name"]
#      author_u = json_post["author"]["name_u"]

      level = json_post["content"]["floor"]
      content =  item.at_css(".d_post_content").inner_html

      if  s == 0
         if (author == lz)
           i += 1
           TiebaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => i ,:author => lz)
         end
      elsif s == 1
        j += 1
        TiebaPost.create!(:page_url_id => url_id, :content => content, :post_at => created_at,
                        :level  => level, :my_level => j ,:author => lz)
      end
    end # end -do each
    return  i if s.eql?(0)
    return  j if s.eql?(1)

    rescue
      puts $!
      return -1
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
    all_post_num = doc.at_css(".p_thread .l_thread_info .l_posts_num li span.red").text
    title = doc.at_css("h1").text
    if doc.at_css("a#tab_home")
      category = doc.at_css("a#tab_home").text
    elsif doc.at_css("li.first > p  > a")
      category = doc.at_css("li.first > p > a").text
    elsif doc.at_css("a.star_title_h3")
      category = doc.at_css("a.star_title_h3").text
    elsif doc.at_css("cb")
      category = doc.at_css("cb").text
    else
      category = "贴吧"
    end
      post_json_str= doc.at_css(".l_post").attr("data-field")
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
                  :tags => title , :section_id => 1 , :rule => 1}
  end




end
