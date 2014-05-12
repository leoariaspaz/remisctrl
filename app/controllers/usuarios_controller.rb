class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:edit, :update, :destroy]
  before_filter :autorizar

  # GET /usuarios
  # GET /usuarios.json
  def index
    @usuarios = Usuario.order(:nombre)
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to usuarios_url, notice: "Se creó correctamente el usuario #{@usuario.nombre}" }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to moviles_url, notice: "Se actualizó correctamente el usuario #{@usuario.nombre.titleize}" }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
		begin
		  @usuario.destroy
		rescue Exception => e
			flash[:notice] = e.message
		end
	  respond_to do |format|		  	
	    format.html { redirect_to usuarios_url }
	  end
  end
  
  def reset_password
  	@u = Usuario.find params[:id]
  	begin
	  	@u.update! password: "123456", password_confirmation: "123456"
			flash[:notice] = "Se reinició la contraseña de #{@u.nombre.titleize}"
  	rescue Exception => e
  		flash[:notice] = "Error: #{e.message}"
  	end
  	respond_to do |format|
  		format.html { redirect_to usuarios_url }
	 	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit(:nombre, :password, :password_confirmation)
    end
end
