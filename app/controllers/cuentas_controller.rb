class CuentasController < ApplicationController
  before_action :set_cuenta, only: [:edit, :update, :destroy]
  before_action :set_selects, only: [:new, :create, :edit, :update]  

  # GET /cuentas
  def index
    @cuentas = Cuenta.all_descriptive.paginate(page: params[:page])
    # @cuentas = Cuenta.all
  end

  # GET /cuentas/1
  def show
  end

  # GET /cuentas/new
  def new
    @cuenta = Cuenta.new
  end

  # GET /cuentas/1/edit
  def edit
  end

  # POST /cuentas
  def create
    @cuenta = Cuenta.new(cuenta_params)

    respond_to do |format|
      if @cuenta.save
        format.html { redirect_to cuentas_url, notice: t('scaffold.save_msg', entity: "La cuenta #{@cuenta.id}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /cuentas/1
  def update
    respond_to do |format|
      if @cuenta.update(cuenta_params)
        format.html { redirect_to cuentas_url, notice: t('scaffold.update_msg', entity: "de la cuenta #{@cuenta.id}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /cuentas/1
  def destroy
    e = EstadoCuenta.all.where(codigo: 3).first
    begin
      @cuenta.update(estado_id: e.id)
      flash[:notice] = "La cuenta #{@cuenta.id} se dio de baja correctamente"
    rescue Exception => ex
      flash[:notice] = "Error: #{ex.message}"
    end
    respond_to do |format|
      format.html { redirect_to cuentas_url }
    end
  end

  def getmovilbyagencia
    params.permit(:id)
    @moviles = Movil.where(agencia_id: params[:id]).select(:id, :nromovil).order(:nromovil)
    render json: @moviles
  end

  def owner
    params.permit(:id)
    render partial: 'details_owner', locals: {owner: Cuenta.find(params[:id])}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuenta
      @cuenta = Cuenta.find(params[:id])
    end

    def set_selects
      @choferes = Chofer.all_for_select
      @agencias = Agencia.all_for_select
      if not @agencias.empty?
        id = @agencias.first[1]
        @moviles = Movil.all_for_select(id)
      else
        @moviles = Movil.all_for_select
      end
      @estados = EstadoCuenta.all_for_select
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuenta_params
      params.require(:cuenta).permit(:chofer_id, :movil_id, :saldo_anterior, :agencia_id, :descripcion)
    end
end
