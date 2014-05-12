module ConfiguracionHelper
	def link_to_config_index
		link_to_index title: "Configuración", 
									url: url_for(controller: "configuracion", action: "index"), 
									controller: ["configuracion", "rellenos", "usuarios", "transacciones", "configuraciones"]
	end
end
