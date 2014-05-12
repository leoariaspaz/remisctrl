class CuentasController < ApplicationController
  before_action :set_cuenta, only: [:show, :edit, :update, :destroy]

  # GET /cuentas
  def index
    @cuentas = Cuenta.all
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
        format.html { redirect_to cuentas_url, notice: t('scaffold.save_msg', entity: "#{@cuenta}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /cuentas/1
  def update
    respond_to do |format|
      if @cuenta.update(cuenta_params)
        format.html { redirect_to cuentas_url, notice: t('scaffold.update_msg', entity: "#{@cuenta}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /cuentas/1
  def destroy
    @cuenta.destroy
    respond_to do |format|
      format.html { redirect_to cuentas_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuenta
      @cuenta = Cuenta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuenta_params
      params.require(:cuenta).permit(:chofer_id, :movil_id, :estado, :saldo_anterior)
    end
end
