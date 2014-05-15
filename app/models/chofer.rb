# encoding: utf-8
class Chofer < ActiveRecord::Base
  before_create :log_estado_inicial
  before_update :log_cambio_estado, if: :estado_id_changed?

	belongs_to :estado, class_name: 'Relleno', foreign_key: 'estado_id'
  has_many   :movil, dependent: :restrict_with_error
  has_many   :logs_estado, as: :estado_loggeable
  has_many   :documentos, as: :documentable 
	
  validates :nombre, :estado_id, :fechaestado, presence: true
  validates :estado_id, inclusion: { in: :estados_validos, message: 'no es uno de los estados válidos' }
  validates :estado_id, numericality: { only_integer: true }
  validates :motivo_cambio_estado, presence: true, if: :estado_id_changed?, on: :update

  attr_accessor :motivo_cambio_estado
  
	def estados_validos
		EstadoChofer.all_for_validate_inclusion
  end
  
  def self.all_for_select
		Chofer.all.order(:nombre, :apodo).map{|c| ["#{c.nombre} (#{c.apodo})", c.id]}
  end
  
  def self.all_for_validate_inclusion
  	Chofer.all_for_select.map{|e| e[1]}
  end

protected
  def log_cambio_estado
    logs_estado.build(estado_id: estado_id, motivo: @motivo_cambio_estado)
  end

  def log_estado_inicial
    logs_estado.build(estado_id: estado_id, motivo: "Estado inicial")
  end
end
