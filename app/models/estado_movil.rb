class EstadoMovil
	ID_RELLENO = 5

  def self.all_for_select
		EstadoMovil.all.map{|r| [r.descripcion, r.id]}
  end
  
  def self.all_for_validate_inclusion
  	EstadoMovil.all_for_select.map{|e| e[1]}
  end

	def self.all
		Relleno.joins(:tipo_relleno).where("tipos_relleno.codigo = #{ID_RELLENO}").order(:descripcion).load
	end
end
