class ApplicationController < ActionController::Base
	before_filter :autenticar, :set_cache_buster	

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
protected
	def autenticar
		unless Usuario.find_by_id(session[:usuario_id])
			redirect_to login_url
		end
	end
	
	def autorizar
		u = Usuario.find(session[:usuario_id])
		unless u.roles.detect {|r| r.derechos.detect {
				|d| (d.action == action_name && d.controller == self.class.controller_path) ||
				(d.action == "*" && d.controller == self.class.controller_path)
			}}
			flash[:notice] = "Ud. no está autorizado a ver la página que solicitó"
			request.env["HTTP_REFERER"]? (redirect_to :back):(redirect_to :root)
			return false
		end		
	end
	
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end	
end
