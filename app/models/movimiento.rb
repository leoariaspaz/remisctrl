class Movimiento < ActiveRecord::Base
  before_create :set_fecha_proceso
  before_update :set_fecha_proceso

  belongs_to :transaccion
  belongs_to :movil
  belongs_to :chofer

  attr_accessor :agencia_id

  validates :fecha_movimiento, :transaccion_id, :movil_id, :chofer_id, presence: true
  validates :importe, numericality: {only_integer: false, greater_than_or_equal_to: 0}, allow_nil: false
  validates :movil_id, inclusion: { in: :moviles_validos, message: 'no es uno de los móviles válidos' }
  validates :chofer_id, inclusion: { in: :choferes_validos, message: 'no es uno de los choferes válidos' }

	def choferes_validos
		Chofer.all_for_validate_inclusion
  end

	def moviles_validos
		Chofer.all_for_validate_inclusion
  end

protected
  def set_fecha_proceso
    fecha_proceso = Configuracion.data.fecha_proceso
  end
end
