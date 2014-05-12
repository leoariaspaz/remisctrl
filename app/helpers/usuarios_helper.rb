module UsuariosHelper
	def is_admin
		u = Usuario.find_by_id(session[:usuario_id])
		u.roles.detect {|r| r.nombre == "Administrador"}
	end
end
