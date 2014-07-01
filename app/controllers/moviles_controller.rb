class MovilesController < ApplicationController
  before_action :set_movil, only: [:show, :edit, :update, :destroy, :print, :print_documentos]
  before_action :set_selects, only: [:new, :create, :edit, :update]  

  # GET /moviles
  def index
    @moviles = Movil.all_descriptive.paginate(page: params[:page])
  end

  # GET /moviles/new
  def new
    @movil = Movil.new
  end

  # GET /moviles/1/edit
  def edit
  end

  # POST /moviles
  def create
    @movil = Movil.new(movil_params)
    respond_to do |format|
      if @movil.save
        format.html { redirect_to moviles_url, notice: t('scaffold.save_msg', entity: "El móvil #{@movil.nromovil}") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /moviles/1
  def update
    respond_to do |format|
      if @movil.update(movil_params)
        format.html { redirect_to moviles_url, notice: t('scaffold.update_msg', entity: "del móvil #{@movil.nromovil}") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /moviles/1
  def destroy
    @movil.destroy
    respond_to do |format|
      format.html { redirect_to moviles_url }
    end
  end

  def show
    @movil = Movil.all_descriptive.where(id: params[:id]).first
  end

  def print
    begin
      params.require(:wa)
    rescue Exception => e
      redirect_to moviles_url
    end
    respond_to do |format|
      format.pdf do
        pdf = MovilPdf.new(@movil, view_context, "Legajo del móvil", params[:wa])
        send_data pdf.render, filename: "Móviles - Legajo del móvil #{@movil.nromovil}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def print_documentos
    respond_to do |format|
      format.pdf do
        pdf = DocumentoPdf::DocumentListPdf.new(@movil.documentos)
        send_data pdf.render, filename: "Documentos del móvil #{@movil.nromovil}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end    
  end

  def getchoferbyagencia
    movil = Movil.where(id: params[:id], agencia_id: params[:agencia_id]).first
    render text: "#{((movil.nil?)? "ninguno":movil.chofer_id)} id = #{params[:id]} agencia_id = #{params[:agencia_id]}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movil
      @movil = Movil.find(params[:id])
    end
    
    def set_selects
      @estados = EstadoMovil.all_for_select
      @agencias = Agencia.all_for_select              
    	@choferes = Chofer.all_for_select
    	@propietarios = Propietario.all_for_select
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movil_params
      params.require(:movil).permit(:nromovil, :marca, :modelo, :dominio, :estado_id, :fecha_estado, 
        :agencia_id, :propietario_id, :chofer_id, :motivo_cambio_estado)
    end
end
