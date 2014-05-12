class ConfiguracionesController < ApplicationController
  before_action :set_configuracion, only: [:edit, :update]

  # GET /configuraciones/1/edit
  def edit
  end

  # PATCH/PUT /configuraciones/1
  def update
    respond_to do |format|
      if @configuracion.update(configuracion_params)
        format.html { redirect_to url_for(controller: "configuracion", action: "index"), notice: t('scaffold.update_msg', entity: "de configuración") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configuracion
      @configuracion = Configuracion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def configuracion_params
      params.require(:configuracion).permit(:fecha_proceso)
    end
end
