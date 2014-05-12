class TransaccionesController < ApplicationController
  before_action :set_transaccion, only: [:show, :edit, :update, :destroy]

  # GET /transacciones
  # GET /transacciones.json
  def index
    @transacciones = Transaccion.all
  end

  # GET /transacciones/1
  # GET /transacciones/1.json
  def show
  end

  # GET /transacciones/new
  def new
    @transaccion = Transaccion.new
  end

  # GET /transacciones/1/edit
  def edit
  end

  # POST /transacciones
  # POST /transacciones.json
  def create
    @transaccion = Transaccion.new(transaccion_params)

    respond_to do |format|
      if @transaccion.save
        format.html { redirect_to transacciones_url, notice: t('scaffold.save_msg', entity: "La transacción #{@transaccion.descripcion}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /transacciones/1
  # PATCH/PUT /transacciones/1.json
  def update
    respond_to do |format|
      if @transaccion.update(transaccion_params)
        format.html { redirect_to transacciones_url, notice: t('scaffold.update_msg', entity: "de la transacción #{@transaccion.descripcion}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /transacciones/1
  # DELETE /transacciones/1.json
  def destroy
    @transaccion.destroy
    respond_to do |format|
      format.html { redirect_to transacciones_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaccion
      @transaccion = Transaccion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaccion_params
      params.require(:transaccion).permit(:descripcion, :sintetico, :tipo, :activo)
    end
end
