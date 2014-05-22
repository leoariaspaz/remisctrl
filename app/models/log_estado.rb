class LogEstado < ActiveRecord::Base
  belongs_to :estado_loggeable, polymorphic: true
  belongs_to :estado, class_name: 'Relleno', foreign_key: 'estado_id'
end
