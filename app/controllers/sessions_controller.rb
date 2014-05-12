class SessionsController < ApplicationController
	skip_before_filter :autenticar, :autorizar, except: [:destroy]

  def new
  	render layout: false
  end

  def create
  	if usuario = Usuario.authenticate(params[:nombre], params[:password])
  		session[:usuario_id] = usuario.id
  		session[:usuario_nombre] = usuario.nombre.titleize
  		redirect_to moviles_path
  	else
  		redirect_to login_url, alert: "El usuario o la contraseña son incorrectos"
  	end  
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to login_url   
  end
end
