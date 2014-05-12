class TipoImagen < ActiveRecord::Base
  has_many :documentos
  has_many :movil, through: :documentos, foreign_key: 'tipo_imagen_id'
  
  validates :descripcion, presence: true
  
  def self.all_for_select
  	#TipoImagen.where(habilitado: true).map{|t| [t.descripcion, t.id]}
		Relleno
			.where(habilitado: true)		
			.joins(:tipo_relleno)
			.where('tipos_relleno.codigo = 6')
			.map{|r| [r.descripcion, r.id]}
  end
  
  def self.all_for_validate_inclusion
  	TipoImagen.all_for_select.map{|e| e[1]}
  end  
end
