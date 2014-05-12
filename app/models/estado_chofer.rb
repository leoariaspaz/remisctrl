class EstadoChofer
  def self.all_for_select
		EstadoChofer.all.map{|r| [r.descripcion, r.id]}
  end
  
  def self.all_for_validate_inclusion
  	EstadoChofer.all_for_select.map{|e| e[1]}
  end

  def self.all
  	Relleno.joins(:tipo_relleno).where('tipos_relleno.codigo = 3').load
  end
end
