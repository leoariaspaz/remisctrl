class Cuenta < ActiveRecord::Base
  belongs_to :chofer
  belongs_to :movil
  belongs_to :estado_cuenta, class_name: 'Relleno', foreign_key: 'estado_id'

  attr_accessor :agencia_id  

  validates :chofer_id, :movil_id, :agencia_id, :estado_id, presence: true
  validates :chofer_id, inclusion: { in: :choferes_validos, message: 'no es un de chofer válido' }
  validates :movil_id, inclusion: { in: :moviles_validos, message: 'no es un móvil válido' }  
  validates :estado_id, inclusion: { in: :estados_validos, message: 'no es un estado válido' }

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
