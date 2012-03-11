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
    all_post_num = doc.at_css(".p_thread .l_thread_info .l_posts_num li span").text
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



  #从首页获取 主题
  def self.create_tieba_topic(doc,fromurl)
    all_page_num = 1

    puts all_page_num

    all_post_num = doc.at_css(".p_thread .l_thread_info .l_posts_num li.l_reply_num span").text
    title = doc.at_css("h1").text
    category = doc.at_css("a#pb_nav_main").text
    post_json_str= doc.at_css(".l_post .p_post").attr("data-field")
		json_post = JSON.parse(post_json_str)
    created_at = json_post["content"]["date"]
    lz = json_post["author"]["name"]

    topic = Topic.new(:title => title, :classname => category, :author => lz,
                      :firsttime => created_at, :sitefirsttime => Time.now, :siteupdatetime => Time.now,
                      :sitepagenum => all_page_num, :sitepostnum => all_post_num, :showtimes => 1,:downtimes => 1,
                      :fromurl => fromurl, :tags => title , :section_id => 1)

    if topic.save
        all_page_num.to_i.times do |a|
          Articleurl.create!(:topic_id => topic.id, :pagenum => a+1, :pageurl => get_tieba_page_url(topic.fromurl,a+1),
                             :pagestatus => 0, :postcount => 1)
        end
    end
  end

  def self.cai_tieba_page doc
    doc.css(".p_thread .l_thread_info .l_posts_num .l_pager a").each do |link|
        if link.text == "尾页"
          href = "http://tieba.baidu.com" << link.attr("href")
          puts "next page is #{href}"
          @temp[:last_from_url] =  href
          doc = Nokogiri::HTML(open(href))
          filter_tieba_post doc
          break
        end
		  end
  end

  def self.renew_tieba topic
    max_page_articleurl = Articleurl.find_by_topic_id(topic.id, :limit => 1,:order => "pagenum DESC")
    max_page = max_page_articleurl.pagenum
    puts "current max page num is " << max_page.to_s
    puts "current max page url is " << max_page_articleurl.pageurl

    articleurl = Articleurl.find_by_topic_id_and_pagenum(topic.id,1, :limit => 1)
    begin
      html_stream  = open(articleurl.pageurl)
    rescue #OpenURI::HTTPError => ex
      #@articleurl.update_attributes(:pagestatus => 9);
      #@articleurl.save!
      puts " can't get url: #{articleurl.pageurl}"
      return
    end
    doc = Nokogiri::HTML(html_stream)

    all_page_num = 1
    doc.css(".p_thread .l_thread_info .l_posts_num .l_pager a").each do |link|
        if link.text == "尾页"
          str = link.attr("href")
          column = str.split(/=/)
          all_page_num = column[1]
          break
        end
    end
    all_post_num = doc.at_css(".p_thread .l_thread_info .l_posts_num li.l_reply_num span").text

    puts all_page_num
    if all_page_num.to_i > max_page.to_i
       (all_page_num.to_i - max_page.to_i).times do |a|
          Articleurl.create!(:topic_id => topic.id, :pagenum => (max_page.to_i + a + 1),
                             :pageurl => get_tieba_page_url(topic.fromurl, (max_page.to_i + a + 1) ),
                             :pagestatus => 0, :postcount => 1)
       end

    else
      TuoShuiJob.delay.tuo_tieba(topic,max_page_articleurl)
    end
    t = {:siteupdatetime => Time.now, :sitepagenum => all_page_num, :sitepostnum => all_post_num}
    @temptopic = Topic.find_by_id(topic.id)
    @temptopic.update_attributes(t)
    @temptopic.save!


  end

  def self.get_tieba_page_url(url,p)
    regEx_tieba_1 = /baidu\.com\/p\/[0-9]*/
    if regEx_tieba_1  =~ url
        if p.eql?(1)
          myurl = ("http://tieba." << regEx_tieba_1.match(url).to_s)
        else
           myurl = ("http://tieba." << regEx_tieba_1.match(url).to_s) << "?pn=#{p}"
        end
    end
    myurl
  end
end