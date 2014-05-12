class LogEstado < ActiveRecord::Base
  belongs_to :estado_loggeable, polymorphic: true

  def estado_movil
		EstadoMovil.all.detect{|e| e.id == estado_id}.descripcion
  end

  def estado_chofer
  	EstadoChofer.all.detect{|e| e.id == estado_id}.descripcion
  end

  def estado_propietario
  	EstadoPropietario.all.detect{|e| e.id == estado_id}.descripcion
  end
end
