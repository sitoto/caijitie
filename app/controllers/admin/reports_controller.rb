class Admin::ReportsController < AdminController
  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
    @topic_num = Topic.count
    @page_num = PageUrl.count
    @pagenot_num = PageUrl.where("status != 1").count

    @nottopic = PageUrl.find_by_sql("SELECT  count(id) as pagenum, topic_id FROM `page_urls`  WHERE `status` != 1  GROUP BY topic_id limit 50")
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
end
