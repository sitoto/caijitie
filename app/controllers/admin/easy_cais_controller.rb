class Admin::EasyCaisController <  AdminController

  def index
    @easy_cais = EasyCai.order("id DESC").page(params[:page]).per(25)
  end

  def show
    @easy_cai = EasyCai.find(params[:id])
  end

  def new
    @easy_cai = EasyCai.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /easy_cais/1/edit
  def edit
    @easy_cai = EasyCai.find(params[:id])
  end

  # POST /easy_cais
  # POST /easy_cais.json
  def create
    @easy_cai = EasyCai.new(easy_cai_params)

    respond_to do |format|
      if @easy_cai.save
        format.html { redirect_to [:admin, @easy_cai], notice: 'EasyCai was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /easy_cais/1
  # PUT /easy_cais/1.json
  def update
    @easy_cai = EasyCai.find(params[:id])

    respond_to do |format|
      if @easy_cai.update_attributes(params[:easy_cai])
        format.html { redirect_to [:admin, @easy_cai], notice: 'EasyCai was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @easy_cai.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /easy_cais/1
  # DELETE /easy_cais/1.json
  def destroy
    @easy_cai = EasyCai.find(params[:id])
    @easy_cai.destroy

    respond_to do |format|
      format.html { redirect_to admin_easy_cais_url }
      format.json { head :ok }
    end
  end

  def easy_cai_params  
    params.require(:easy_cai).permit(:section_id ,:name,  :rule_id, :url_address, :paixu ,:status)  
  end  
end
