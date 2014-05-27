class MovimientosController < ApplicationController
  before_action :set_movimiento, only: [:show, :edit, :update, :destroy]
  before_action :set_selects, only: [:new, :create, :edit, :update]  

  # GET /movimientos
  def index
    @movimientos = Movimiento.all_descriptive.paginate(page: params[:page])
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
    begin
      @movimiento.update(es_contrasiento: true, fecha_contrasiento: DateTime.now)
      flash[:notice] = 'El movimiento se contrasentó correctamente'
    rescue Exception => e
      flash[:notice] = "Error: #{e.message}"
    end
    respond_to do |format|
      format.html { redirect_to movimientos_url}
    end
  end

  # GET /movimientos/consultar
  def consultar
    @movimientos_search = MovimientoSearch.new
  end

  # GET /movimientos/consultar_agrupado
  def consultar_agrupado
    search = params.require(:search).permit(:tipo_informe, :fecha_desde, :fecha_hasta, 
                :nromovil_desde, :nromovil_hasta, :mostrar_contrasientos)
    @movimientos_search = MovimientoSearch.new(search)
    if @movimientos_search.valid?
      case @movimientos_search.tipo_informe.to_sym
        when :por_movil
          pdf = MovimientoMovilPdf.new(@movimientos_search, view_context)
        when :por_utilidad
          pdf = MovimientoUtilidadPdf.new(@movimientos_search, view_context)
        when :por_transaccion
          pdf = MovimientoTransaccionPdf.new(@movimientos_search, view_context)
      end
      if not pdf.nil?
        send_data pdf.render, filename: pdf.file_name,
                              type: "application/pdf",
                              disposition: "inline"
      end
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
