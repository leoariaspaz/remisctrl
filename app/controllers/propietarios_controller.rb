class PropietariosController < ApplicationController
  before_action :set_propietario, only: [:edit, :update, :destroy, :show, :print]
  before_action :set_selects, only: [:new, :create, :edit, :update]

  # GET /propietarios
  # GET /propietarios.json
  def index
    @propietarios = Propietario.all_descriptive.paginate(page: params[:page])
  end

  # GET /propietarios/new
  def new
    @propietario = Propietario.new
  end

  def show    
  end

  # GET /propietarios/1/edit
  def edit
  end

  # POST /propietarios
  # POST /propietarios.json
  def create
    @propietario = Propietario.new(propietario_params)

    respond_to do |format|
      if @propietario.save
        format.html { redirect_to propietarios_url, notice: t('scaffold.save_msg', entity: "El propietario #{@propietario.nombre}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /propietarios/1
  # PATCH/PUT /propietarios/1.json
  def update
    respond_to do |format|
      if @propietario.update(propietario_params)
        format.html { redirect_to propietarios_url, notice: t('scaffold.update_msg', entity: "del propietario #{@propietario.nombre}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /propietarios/1
  # DELETE /propietarios/1.json
  def destroy
    @propietario.destroy
    respond_to do |format|
      format.html { redirect_to propietarios_url }
    end
  end
  
  def detail_select
  	p = Propietario.find params[:id]
  	render partial: 'detail_select', locals: { propietario: p }
  end

  def print
    respond_to do |format|
      format.pdf do
        pdf = PropietarioPdf.new(@propietario, view_context, "Legajo del propietario")
        send_data pdf.render, filename: "Propietarios - Legajo de #{@propietario.nombre}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_propietario
      @propietario = Propietario.find(params[:id])
    end
    
    def set_selects
      @tipo_docs = TipoDoc.all_for_select
      @estados = EstadoPropietario.all_for_select    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def propietario_params
      params.require(:propietario).permit(:nombre, :nrodoc, :tipo_doc_id, :fecha_alta, :estado_id, :fecha_estado,
        :motivo_cambio_estado)
    end
end
