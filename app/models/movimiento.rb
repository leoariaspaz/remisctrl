class Movimiento < ActiveRecord::Base
  before_create :set_fecha_proceso
  before_update :set_fecha_proceso

  belongs_to :transaccion
  belongs_to :cuenta
  delegate   :movil, to: :cuenta

  attr_accessor :agencia_id

  validates :fecha_movimiento, :transaccion_id, :cuenta_id, presence: true
  validates :importe, numericality: {only_integer: false, greater_than_or_equal_to: 0}, allow_nil: false
  validates :cuenta_id, inclusion: { in: :cuentas_validas, message: 'no es una cuenta correcta' }

  def self.all_descriptive
    joins(:transaccion, :cuenta).
      joins(%{INNER JOIN moviles m ON m.id = cuentas.movil_id 
              INNER JOIN choferes c ON c.id = cuentas.chofer_id}).
      order(%{movimientos.fecha_movimiento DESC, movimientos.created_at DESC}).
      select(%{movimientos.*, transacciones.descripcion AS transaccion_movimiento, 
               m.nromovil, c.apodo AS apodo_chofer, c.nombre AS nombre_chofer})
  end

  def nombre_cuenta
    nombre = nombre_chofer
    if not apodo_chofer.blank? 
      nombre += " (#{apodo_chofer})"
    end
    nombre
  end  

  def cuentas_validas
    Cuenta.all_for_validate_inclusion
  end

  def nro_cuenta
    "%07d" % cuenta_id
  end

protected
  def set_fecha_proceso
    fecha_proceso = Configuracion.current.fecha_proceso
  end
end
