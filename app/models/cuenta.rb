class Cuenta < ActiveRecord::Base
  before_create :set_estado

  belongs_to :chofer
  belongs_to :movil
  belongs_to :estado_cuenta, class_name: 'Relleno', foreign_key: 'estado_id'

  attr_accessor :agencia_id  

  validates :chofer_id, :movil_id, :agencia_id, presence: true
  validates :estado_id, presence: true, on: :update
  validates :chofer_id, inclusion: { in: :choferes_validos, message: 'no es un de chofer válido' }
  validates :movil_id, inclusion: { in: :moviles_validos, message: 'no es un móvil válido' }  
  validates :estado_id, inclusion: { in: :estados_validos, message: 'no es un estado válido' }, on: :update

  def self.all_descriptive
    Cuenta.
      joins(:chofer, :movil, :estado_cuenta).
      select( "cuentas.*, choferes.apodo AS apodoChofer, choferes.nombre AS nombreChofer," + 
              "moviles.nromovil, rellenos.descripcion AS estado" )
  end

  def agencia_id
    if not movil_id.blank?
      @agencia_id = movil.agencia_id
    end
  end

  def nombre_chofer
    nombre = nombreChofer
    if not apodoChofer.blank? 
      nombre += " (#{apodoChofer})"
    end
    nombre
  end

  def set_estado
    ec = EstadoCuenta.all.where(descripcion: "Nueva").first
    self.estado_id = ec.id
    logger.debug "estado_id = #{self.estado_id}"
    true
  end

private
	def choferes_validos
		Chofer.all_for_validate_inclusion
  end

	def moviles_validos
		Movil.all_for_validate_inclusion(@agencia_id)
  end

  def estados_validos
    EstadoCuenta.all_for_validate_inclusion
  end
end
