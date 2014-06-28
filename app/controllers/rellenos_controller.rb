class RellenosController < ApplicationController
  before_action :set_relleno_and_index_url, only: [:edit, :update, :destroy]

  # GET /rellenos
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
  def create
    @relleno = Relleno.new(relleno_params)

    respond_to do |format|
      if @relleno.save
      	set_index_url
        format.html { redirect_to @index_url, notice: t('scaffold.save_msg', entity: @relleno.tipo_relleno.descripcion.downcase.camelize) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /rellenos/1
  def update
    respond_to do |format|
      if @relleno.update(relleno_params)      	
        format.html { redirect_to @index_url, notice: t('scaffold.update_msg', entity: "de " + @relleno.tipo_relleno.descripcion.downcase.camelize) }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /rellenos/1
  def destroy
    n = 'El registro se eliminó correctamente'
    begin
      @relleno.destroy 
    rescue ActiveRecord::DeleteRestrictionError => e
      n = "No se puede eliminar el registro: hay registros relacionados"
    end 
    respond_to do |format|
      format.html { redirect_to @index_url, notice: n }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relleno_and_index_url
      @relleno = Relleno.find(params[:id])
      set_index_url
      logger.debug "@relleno = #{@relleno}, @index_url = #{@index_url}"
    end
    
    def set_index_url
			@index_url = rellenos_url(id: @relleno.tipo_relleno_id)    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relleno_params
      params.require(:relleno).permit(:codigo, :descripcion, :sintetico, :habilitado, :tipo_relleno_id)
    end
end
