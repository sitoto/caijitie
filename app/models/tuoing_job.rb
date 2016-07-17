class TuoingJob < Struct.new(:topic_id, :page_url_id)
   def perform
     #puts topic_id
     @topic = topic_id #Topic.find(topic_id)
     @page_url = page_url_id #PageUrl.find(page_url_id)
      if (@page_url.status != 1 && @page_url.status != 2)
        @page_url.update_attributes!(:status => 2)

        t = TiebaTuoshuiJob.get_tieba_post(@topic, @page_url) if @topic.rule == 1
        t = TianyabbsTuoshuiJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 2
        t = DoubanhuatiTuoshuiJob.get_doubanhuati_post(@topic, @page_url) if @topic.rule == 3
        t = TianyabbsTechforumJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 4
        t = TianyabbsBbsJob.get_tianyabbs_post(@topic, @page_url) if @topic.rule == 5

        puts "#{@topic.title} return the post count is:  #{t}"
        @page_url.update_attributes!(:status => 1,:count => t ) if t >=  0 #读取正确 状态为 1
        @page_url.update_attributes!(:status => 9) if t == -1 #读取出错 状态 改为 9
      end
  end
end
