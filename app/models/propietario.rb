class Propietario < ActiveRecord::Base
  before_create :log_estado_inicial
  before_update :log_cambio_estado, if: :estado_id_changed?

  belongs_to  :tipo_doc, class_name: 'Relleno', foreign_key: 'tipo_doc_id'
  belongs_to  :estado, class_name: 'Relleno', foreign_key: 'estado_id'
  has_many    :movil, dependent: :restrict_with_error
  has_many    :logs_estado, as: :estado_loggeable
  has_many    :documentos, as: :documentable
  
  validates :nombre, :nrodoc, :tipo_doc_id, :fecha_alta, :estado_id, :fecha_estado, presence: true
  validates :nombre, uniqueness: { scope: [:nrodoc, :tipo_doc_id], case_sensitive: false }
	validates :nrodoc, uniqueness: { scope: [:tipo_doc_id]}
  validates :tipo_doc_id, inclusion: { in: :tipo_doc_validos, 
  						message: 'no es uno de los tipos de documentos válidos' }
  validates :estado_id, inclusion: { in: :estados_validos, 
  						message: 'no es uno de los estados válidos' }
  validates :nrodoc, :tipo_doc_id, :estado_id, numericality: { only_integer: true }
  validates :motivo_cambio_estado, presence: true, if: :estado_id_changed?, on: :update  
  
  attr_accessor :motivo_cambio_estado

  def self.all_descriptive
    Propietario.
      joins(:tipo_doc, :estado).
      select(%{ propietarios.*, rellenos.sintetico AS tipo_doc_propietario, 
                 estados_propietarios.descripcion AS estado_propietario })
  end
  
	def estados_validos
		EstadoPropietario.all_for_validate_inclusion
  end  

	def tipo_doc_validos
		TipoDoc.all_for_validate_inclusion
  end
  
  def self.all_for_select
		Propietario.all.map{|c| [c.nombre, c.id]}
  end
  
  def self.all_for_validate_inclusion
  	Propietario.all_for_select.map{|e| e[1]}
  end

protected
  def log_cambio_estado
    logs_estado.build(estado_id: estado_id, motivo: @motivo_cambio_estado)
  end

  def log_estado_inicial
    logs_estado.build(estado_id: estado_id, motivo: "Estado inicial")
  end
end
