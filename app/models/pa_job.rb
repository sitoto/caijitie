#encoding: utf-8
require 'get_tieba_page_url'
class PaJob < Struct.new(:url)
  include GetTiebaPageUrl

   def perform
     s_id = is_url?(url)
     if s_id.eql?(0)
       return
#     elsif  PageUrl.find_by_sql(["select * from page_urls where url = ? ", @url]).first
#       return
     elsif Topic.find_by_sql(["select * from topics where fromurl = ? ", @url]).first
       return
     else
       #do something
         @topic = Topic.new()
        case s_id
          when 1
            t = @topic.get_tieba_topic(@url)
            update_topic(t)
          when 2
           t, page_urls = @topic.get_tianya_topic(@url)
            update_tianyabbs_topic(t, page_urls)
          when 3
           t =  @topic.get_douban_topic(@url)
            update_doubanhuati_topic(t)
          when 4 #techforum from tianyabbs 鬼话
           t, page_urls = @topic.get_tianya_techforum_topic(@url)
            update_tianyabbs_techfroum_topic(t)
        end
     end

   end

   protected
   def update_topic(t)
      unless t.blank?
         t[:fromurl] = @url
         t[:my_title] = t[:title]
         @topic.update_attributes(t)
         if @topic.save
            max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
            max = 1 if max == 0
            max.upto(@topic.mypagenum)  do |a|
             @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tieba_page_url(@topic.fromurl,a),
                                :status => 0, :count => 1)
             Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
             #TiebaTuoshuiJob.get_tieba_post(@topic, @page_url)
           end
         end

      end
   end
   def update_doubanhuati_topic(t)
      unless t.blank?
         t[:fromurl] = @url
         t[:my_title] = t[:title]
         @topic.update_attributes(t)
         if @topic.save
            max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
            max = 1 if max == 0
            max.upto(@topic.mypagenum)  do |a|
             @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_doubanhuati_page_url(@topic.fromurl,(a-1) * 100),
                                :status => 0, :count => 1)
             Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
           end
         end

      end
   end
   def update_tianyabbs_topic(t, page_urls)
      unless t.blank?
         t[:my_title] = t[:title]
         @topic.update_attributes(t)
         if @topic.save
            max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
            if page_urls.length == 1
              if max == 0
                @page_url = PageUrl.create!(:topic_id => @topic.id, :num => 1, :url => page_urls[0],
                                :status => 0, :count => 1)
                Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
              end
            elsif page_urls.length > 1
              page_urls.to_a.each_with_index  do |p, i|
               if i >= max
                 @page_url =  PageUrl.create!(:topic_id => @topic.id, :num => i+1, :url => get_tianya_page_url(@topic.fromurl, p),
                                  :status => 0, :count => 1)
                 Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
               end
              end
           end
         end
      end
   end
   def update_tianyabbs_techfroum_topic(t)
     unless t.blank?
       t[:my_title] = t[:title]
       t[:fromurl] = @url
         @topic.update_attributes(t)
         if @topic.save
            max = PageUrl.count_by_sql(["select max(num) from page_urls where topic_id = ?  ",@topic.id]) || 0
            max = 1 if max == 0
            max.upto(@topic.mypagenum)  do |a|
             @page_url = PageUrl.create!(:topic_id => @topic.id, :num => a, :url => get_tianya_techfroum_page_url(@topic.fromurl, a),
                                :status => 0, :count => 1)
             Delayed::Job.enqueue TuoingJob.new(@topic, @page_url)
           end
         end

      end
   end

   def is_url?(url)
      regEx_tieba_1 = /baidu\.com\/p\/[0-9]*/
      regEx_tieba_2 = /baidu\.com\/f\?kz=[0-9]*/
      regEx_tieba_2_1 = /[0-9]+/
      regEx_tianya_1 = /tianya\.cn\/publicforum\/\w*\/\w*\/[0-9]+\/[0-9]+\.shtml/
      regEx_tianya_2 = /tianya\.cn\/techforum\/\w*\/\w*\/[0-9]+\/[0-9]+\.shtml/
      regEx_douban_1 = /douban\.com\/group\/topic\/[0-9]*/
        sid = 0
       if regEx_tieba_1  =~ url
         sid = 1
         @url = ("http://tieba." << regEx_tieba_1.match(url).to_s)
       elsif regEx_tieba_2  =~ url
         sid = 1
          @url = ("http://tieba.baidu.com/p/" << regEx_tieba_2_1.match(url).to_s)
       elsif regEx_tianya_1 =~ url
         sid = 2
         @url ="http://www." << regEx_tianya_1.match(url).to_s
       elsif regEx_tianya_2 =~ url
         sid = 4
         @url ="http://www." << regEx_tianya_2.match(url).to_s
       elsif regEx_douban_1 =~ url
         sid = 3
         @url = ("http://www." << regEx_douban_1.match(url).to_s << "/")
       end

     sid
   end

end