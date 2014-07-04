class Movil < ActiveRecord::Base
  before_create :log_estado_inicial
  before_update :log_cambio_estado, if: :estado_id_changed?
  before_save   :reset_fecha_cambio

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
  validates :fecha_cambio_embrague, presence: true, 
              unless: Proc.new {|m| m.ultimo_cambio_embrague_km.zero? || m.ultimo_cambio_embrague_km.nil? }
  validates :fecha_cambio_correa_dist, presence: true, 
              unless: Proc.new {|m| m.ultimo_cambio_correa_dist_km.zero? || m.ultimo_cambio_correa_dist_km.nil? }

  attr_accessor :motivo_cambio_estado

  def self.all_descriptive
    all.
      joins(:estado).
      joins(%{  LEFT JOIN rellenos AS agencias ON moviles.agencia_id = agencias.id
                LEFT JOIN propietarios ON moviles.propietario_id = propietarios.id
                LEFT JOIN choferes ON moviles.chofer_id = choferes.id }).
      order(:nromovil).
      select(%{moviles.*, rellenos.descripcion AS estado_movil, agencias.descripcion AS agencia_movil,
               propietarios.nombre AS propietario_movil, choferes.nombre AS chofer_movil })
  end

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

  def logs
    logs_estado.joins(:estado).
      select("logs_estado.*, rellenos.descripcion AS estado_log").
      order(created_at: :desc)
  end  

protected
  def log_cambio_estado
    logs_estado.build(estado_id: estado_id, motivo: @motivo_cambio_estado)
  end

  def log_estado_inicial
    logs_estado.build(estado_id: estado_id, motivo: "Estado inicial")
  end

  def reset_fecha_cambio
    if @ultimo_cambio_embrague_km.nil? || @ultimo_cambio_embrague_km.zero?
      self.fecha_cambio_embrague = nil
    end
    if @ultimo_cambio_correa_dist_km.nil? || @ultimo_cambio_correa_dist_km.zero?
      self.fecha_cambio_correa_dist = nil
    end
  end
end
