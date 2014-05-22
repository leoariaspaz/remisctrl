class Movimiento < ActiveRecord::Base
  before_create :set_fecha_proceso
  before_update :set_fecha_proceso

  belongs_to :transaccion
  belongs_to :cuenta

  attr_accessor :agencia_id

  validates :fecha_movimiento, :transaccion_id, :cuenta_id, presence: true
  validates :importe, numericality: {only_integer: false, greater_than_or_equal_to: 0}, allow_nil: false
  validates :cuenta_id, inclusion: { in: :cuentas_validas, message: 'no es una cuenta correcta' }

	def choferes_validos
		Chofer.all_for_validate_inclusion
  end

	def moviles_validos
		Chofer.all_for_validate_inclusion
  end

  def cuentas_validas
    Cuenta.all_for_validate_inclusion
  end

protected
  def set_fecha_proceso
    fecha_proceso = Configuracion.current.fecha_proceso
  end
end
