class DocumentosController < ApplicationController
  before_action :set_documento, only: [:show, :destroy]
  before_action :set_selects, only: [:new, :create]
  before_action :load_documentable

  # GET /documentos
  # GET /documentos.json
  def index
    @documentos = Documento.all
  end

  # GET /documentos/1
  # GET /documentos/1.json
  def show
  	send_file @documento.imagen.current_path
  end

  # GET /documentos/new
  def new
    @documento = @documentable.documentos.build
  end

  # POST /documentos
  # POST /documentos.json
  def create
    @documento = @documentable.documentos.build(documento_params)
    respond_to do |format|
      if @documentable.save
        format.html { redirect_to @documentable, 
          notice: t('scaffold.save_msg', entity: "El documento #{@documento.tipo_imagen.descripcion} ") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # DELETE /documentos/1
  # DELETE /documentos/1.json
  def destroy
    @documento.destroy
    respond_to do |format|
      format.html { redirect_to [@documentable] }
    end
  end

  def print
    respond_to do |format|
      format.pdf do
        logger.debug "@documentable.class = #{@documentable.class}"
        pdf = DocumentoPdf::DocumentListPdf.new(@documentable.documentos)
        send_data pdf.render, filename: "Documentos del móvil.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end    
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params[:id])
    end
    
    def set_selects
    	@tipos_imagen = TipoImagen.all_for_select
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def documento_params
      params.require(:documento).permit(:movil_id, :tipo_imagen_id, :imagen, :imagen_cache)
    end

    def load_documentable
      resource, id = request.path.split('/')[1, 2]
      @documentable = resource.singularize.classify.constantize.find(id)
    end
end
