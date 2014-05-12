class RellenosController < ApplicationController
  before_action :set_relleno_and_index_url, only: [:edit, :update, :destroy]

  # GET /rellenos
  # GET /rellenos.json
  def index
    @rellenos = nil
    @value = nil
    if params[:id].present?
    	@value = params[:id]
    	@rellenos = Relleno.where(tipo_relleno_id: params[:id])
    end
  end

  # GET /rellenos/new
  def new
  	if params[:tipo_relleno_id].present?
    	@relleno = Relleno.new(:tipo_relleno_id => params[:tipo_relleno_id])
    else
    	redirect_to rellenos_url
    end
  end

  # GET /rellenos/1/edit
  def edit
  end

  # POST /rellenos
  # POST /rellenos.json
  def create
    @relleno = Relleno.new(relleno_params)

    respond_to do |format|
      if @relleno.save
      	set_index_url
        format.html { redirect_to @index_url, notice: t('scaffold.save_notice') }
        format.json { render action: 'index', status: :created, location: @relleno }
      else
        format.html { render action: 'new' }
        format.json { render json: @relleno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rellenos/1
  # PATCH/PUT /rellenos/1.json
  def update
    respond_to do |format|
      if @relleno.update(relleno_params)      	
        format.html { redirect_to @index_url, notice: t('scaffold.save_notice') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @relleno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rellenos/1
  # DELETE /rellenos/1.json
  def destroy
    @relleno.destroy
    respond_to do |format|
      format.html { redirect_to @index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relleno_and_index_url
      @relleno = Relleno.find(params[:id])
      set_index_url      
    end
    
    def set_index_url
			@index_url = rellenos_url(id: @relleno.tipo_relleno_id)    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relleno_params
      params.require(:relleno).permit(:codigo, :descripcion, :sintetico, :habilitado, :tipo_relleno_id)
    end
end
