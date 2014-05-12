class Cuenta < ActiveRecord::Base
  belongs_to :chofer
  belongs_to :movil
end
