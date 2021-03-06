#encoding: UTF-8
require 'nokogiri'
require 'open-uri'
class Admin::ReportsController < AdminController
  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
    @topic_count = Topic.count
    @topic_count_9 = Topic.where(status: 9).count
    @page_status = PageUrl.find_by_sql("SELECT `status`, count(`status`) as count FROM `page_urls` GROUP BY `status` ")

    #@nottopic = PageUrl.find_by_sql("SELECT  count(id) as pagenum, topic_id FROM `page_urls`  WHERE `status` != 1  GROUP BY topic_id limit 50")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    @page_urls = PageUrl.where("status = 0").limit(@report.page_num)

    if(@page_urls.length.eql?(0))

      tianya_url('http://www.tianya.cn/publicforum/articleslist/0/funinfo.shtml')
      @bankuai.each do |t|
        if t[3].size >= 3 && t[3].size <= 4
          Delayed::Job.enqueue(PaJob.new(t[5]), -5)
        end
      end
    end

    @page_urls.each do |p|
      @topic = Topic.find(p.topic_id)
      Delayed::Job.enqueue(TuoingJob.new(@topic, p), -3)
    end

    respond_to do |format|
      if @report.save
        format.html { redirect_to [:admin,@report], notice: 'Report was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to [:admin,@report], notice: 'Report was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to admin_reports_url }
      format.json { head :ok }
    end
  end

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


end
