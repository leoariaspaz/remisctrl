class Relleno < ActiveRecord::Base
	belongs_to :tipo_relleno
	has_many :chofer_estado, foreign_key: 'estado_id', dependent: :restrict_with_error
	has_many :propietario_tipo_doc, foreign_key: 'tipo_doc_id', dependent: :restrict_with_error
	has_many :propietario_estado, foreign_key: 'estado_id', dependent: :restrict_with_error
	has_many :movil_estado, foreign_key: 'estado_id', dependent: :restrict_with_error
	has_many :movil_agencia, foreign_key: 'agencia_id', dependent: :restrict_with_error
	has_many :cuenta_estado, foreign_key: 'estado_id', dependent: :restrict_with_error	

	validates :descripcion, :sintetico, uniqueness: { scope: [:tipo_relleno_id], 
		case_sensitive: false }
  validates :descripcion, :codigo, :sintetico, :tipo_relleno_id, presence: true
	validates_associated :tipo_relleno
end
