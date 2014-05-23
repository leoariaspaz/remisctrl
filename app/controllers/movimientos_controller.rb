class MovimientosController < ApplicationController
  before_action :set_movimiento, only: [:show, :edit, :update, :destroy]
  before_action :set_selects, only: [:new, :create, :edit, :update]  

  # GET /movimientos
  def index
    @movimientos = Movimiento.all_descriptive
  end

  # GET /movimientos/1
  def show
  end

  # GET /movimientos/new
  def new
    @movimiento = Movimiento.new
  end

  # GET /movimientos/1/edit
  def edit
  end

  # POST /movimientos
  def create
    @movimiento = Movimiento.new(movimiento_params)

    respond_to do |format|
      if @movimiento.save
        format.html { redirect_to movimientos_url, notice: t('scaffold.save_msg', entity: "El movimiento") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /movimientos/1
  def update
    respond_to do |format|
      if @movimiento.update(movimiento_params)
        format.html { redirect_to movimientos_url, notice: t('scaffold.update_msg', entity: "El movimiento") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /movimientos/1
  def destroy
    @movimiento.destroy
    respond_to do |format|
      format.html { redirect_to movimientos_url }
    end
  end

  # GET /movimientos/consultar
  def consultar
    @movimientos_search = MovimientoSearch.new
  end

  # GET /movimientos/consultar_por_criterio
  def consultar_agrupado
    search = params.require(:search).permit(:tipo_informe, :fecha_desde, :fecha_hasta, 
                :nromovil_desde, :nromovil_hasta)
    @movimientos_search = MovimientoSearch.new(search)
    if @movimientos_search.valid?
      pdf = MovimientoSearchPdf.new(@movimientos_search, view_context)
      send_data pdf.render, filename: pdf.file_name,
                            type: "application/pdf",
                            disposition: "inline"
    else
      render action: 'consultar'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimiento
      @movimiento = Movimiento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movimiento_params
      params.require(:movimiento).permit(:fecha_movimiento, :transaccion_id, :observacion, :importe, :cuenta_id)
    end

    def set_selects
      @transacciones = Transaccion.all_for_select
      @cuentas = Cuenta.all_for_select
    end
end
