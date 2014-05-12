class EstadoPropietario
  def self.all_for_select
  	self.all.map{|r| [r.descripcion, r.id]}
  end
  
  def self.all_for_validate_inclusion
  	self.all_for_select.map{|e| e[1]}
  end	

  def self.all
  	Relleno.where(habilitado: true).joins(:tipo_relleno).where('tipos_relleno.codigo = 4').load
  end
end
