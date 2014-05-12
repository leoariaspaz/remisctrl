class TiposRellenoController < ApplicationController
  before_action :set_tipo_relleno, only: [:show, :edit, :update, :destroy]

  # GET /tipos_relleno
  # GET /tipos_relleno.json
  def index
    @tipos_relleno = TipoRelleno.all
  end

  # GET /tipos_relleno/new
  def new
    @tipo_relleno = TipoRelleno.new
  end

  # GET /tipos_relleno/1/edit
  def edit
  end

  # POST /tipos_relleno
  # POST /tipos_relleno.json
  def create
    @tipo_relleno = TipoRelleno.new(tipo_relleno_params)

    respond_to do |format|
      if @tipo_relleno.save
        format.html { redirect_to tipos_relleno_url, notice: t('scaffold.save_notice') }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /tipos_relleno/1
  # PATCH/PUT /tipos_relleno/1.json
  def update
    respond_to do |format|
      if @tipo_relleno.update(tipo_relleno_params)
        format.html { redirect_to tipos_relleno_url, notice: t('scaffold.save_notice') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /tipos_relleno/1
  # DELETE /tipos_relleno/1.json
  def destroy
    @tipo_relleno.destroy
    respond_to do |format|
      format.html { redirect_to tipos_relleno_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_relleno
      @tipo_relleno = TipoRelleno.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_relleno_params
      params.require(:tipo_relleno).permit(:descripcion, :codigo)
    end
end
