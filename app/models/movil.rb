class Movil < ActiveRecord::Base
  before_create :log_estado_inicial
  before_update :log_cambio_estado, if: :estado_id_changed?

  belongs_to	:estado, class_name: 'Relleno', foreign_key: 'estado_id'
  belongs_to	:agencia, class_name: 'Relleno', foreign_key: 'agencia_id'
  belongs_to	:propietario
  belongs_to	:chofer
  has_many		:documentos, as: :documentable
  has_many 		:tipo_imagen, class_name: 'Relleno', foreign_key: 'tipo_imagen_id', through: :documentos
  has_many    :logs_estado, as: :estado_loggeable

  validates :dominio, uniqueness: true
  validates :nromovil, :estado, :fecha_estado, presence: true
  validates :modelo, numericality: { only_integer: true }, allow_nil: true
  validates :estado_id, inclusion: { in: :estados_validos, 
  						message: 'no es uno de los estados válidos' }
  validates :agencia_id, inclusion: { in: :agencias_validos, 
  						message: 'no es una de las agencias válidas' }, 
  						unless: Proc.new { |m| m.agencia_id.nil? }
  validates :chofer_id, inclusion: { in: :choferes_validos, 
  						message: 'no es uno de los choferes válidos' }, 
  						unless: Proc.new { |m| m.chofer_id.nil? }
  validates :propietario_id, inclusion: { in: :propietarios_validos, 
  						message: 'no es uno de los propietarios válidos' }, 
  						unless: Proc.new { |m| m.propietario_id.nil? }
  validates :motivo_cambio_estado, presence: true, if: :estado_id_changed?, on: :update

  attr_accessor :motivo_cambio_estado

	def estados_validos
		EstadoMovil.all_for_validate_inclusion		
  end

	def agencias_validos
		Agencia.all_for_validate_inclusion
  end  

	def choferes_validos
		Chofer.all_for_validate_inclusion
  end  

	def propietarios_validos
		Propietario.all_for_validate_inclusion
  end

  def self.all_for_select(agencia_id = nil)
    if agencia_id.nil?
      Movil.all.order(:nromovil).map{|r| [r.nromovil, r.id]}
    else
      Movil.where(agencia_id: agencia_id).order(:nromovil).map{|r| [r.nromovil, r.id]}
    end
  end

  def self.all_for_validate_inclusion(agencia_id = nil)
    Movil.all_for_select(agencia_id).map{|t| t[1]}
  end  

protected
  def log_cambio_estado
    logs_estado.build(estado_id: estado_id, motivo: @motivo_cambio_estado)
  end

  def log_estado_inicial
    logs_estado.build(estado_id: estado_id, motivo: "Estado inicial")
  end
end
