class TipoRelleno < ActiveRecord::Base
	has_many :relleno, dependent: :restrict_with_error
	
	validates :descripcion, :codigo, presence: true
	validates :descripcion, :codigo, uniqueness: true
	validates :codigo, numericality: { only_integer: true, greater_than: 0}
	
	def self.all_for_select
		all.collect{|t| [t.descripcion, t.id]}
	end
end
