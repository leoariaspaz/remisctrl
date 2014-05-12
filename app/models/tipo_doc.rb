class TipoDoc
  def self.all_for_select
		Relleno
			.where(habilitado: true)		
			.joins(:tipo_relleno)
			.where('tipos_relleno.codigo = 2')
			.map{|r| [r.sintetico, r.id]}
  end
  
  def self.all_for_validate_inclusion
  	TipoDoc.all_for_select.map{|t| t[1]}
  end
end
