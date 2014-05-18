class ChoferesController < ApplicationController
  before_action :set_chofer, only: [:edit, :update, :destroy, :show, :print]

  # GET /choferes
  def index
    @choferes = Chofer.all_descriptive.paginate(page: params[:page])
  end

  # GET /choferes/new
  def new
    @chofer = Chofer.new
  end

  # GET /choferes/1/edit
  def edit
  end

  # GET /choferes/1
  def show
  end

  # POST /choferes
  def create
    @chofer = Chofer.new(chofer_params)

    respond_to do |format|
      if @chofer.save
        format.html { redirect_to choferes_url, notice: t('scaffold.save_msg', entity: "El chofer #{@chofer.nombre}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /choferes/1
  def update
    respond_to do |format|
      if @chofer.update(chofer_params)
        format.html { redirect_to choferes_url, notice: t('scaffold.update_msg', entity: "de #{@chofer.nombre}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /choferes/1
  def destroy
    @chofer.destroy
    respond_to do |format|
      format.html { redirect_to choferes_url }
    end
  end
  
  def detail_select
  	c = Chofer.find params[:id]
    render partial: 'detail_select', locals: { chofer: c }
  end

  def print
    respond_to do |format|
      format.pdf do
        pdf = ChoferPdf.new(@chofer, view_context, "Legajo del chofer")
        send_data pdf.render, filename: "Choferes - Legajo de #{@chofer.nombre}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chofer
      @chofer = Chofer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chofer_params
      params.require(:chofer).permit(:nombre, :apodo, :estado_id, :fechaestado, 
      	:credencial, :vtocarnet, :direccion, :telefono, :celular, :motivo_cambio_estado)
    end
end
