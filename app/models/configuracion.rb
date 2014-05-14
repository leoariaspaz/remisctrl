class Configuracion < ActiveRecord::Base
	before_save :set_fecha_proceso_sin_hora

	def self.current
	  where(id: 1).first
	end
	
private
	def set_fecha_proceso_sin_hora
		fecha_proceso = fecha_proceso.to_s
	end
end
