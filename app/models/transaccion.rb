class Transaccion < ActiveRecord::Base
	before_save :set_es_debito
	TipoTransaccion = {credito: "Crédito", debito: "Débito"}
	attr_accessor :tipo

	validates :descripcion, :sintetico, presence: true
	validates :descripcion, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
	validates :sintetico, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
	validates :tipo, inclusion: { in: lambda {|tipo| TipoTransaccion.map{|k,v| k.to_s}},
		message: "no es uno de los tipos válidos" }

	def tipo
		(self.es_debito)? :debito.to_s : :credito.to_s
	end

  def self.all_for_select
		Transaccion.where(activo: true).map{|r| [r.descripcion, r.id]}
  end

  def self.all_for_validate_inclusion
  	Transaccion.all_for_select.map{|t| t[1]}
  end

protected
	def set_es_debito
		self.es_debito = @tipo == :debito.to_s
		return true
	end

end
