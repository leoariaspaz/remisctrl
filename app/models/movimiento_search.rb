class MovimientoSearch
  include ActiveModel::Validations

	TipoInforme = {	por_movil: "Número de móvil",
									por_utilidad: "Utilidad",
									por_transaccion: "Transacción" }

	attr_accessor :tipo_informe, :fecha_desde, :fecha_hasta, :nromovil_desde, :nromovil_hasta
	attr_accessor :mostrar_contrasientos

	validates :tipo_informe, :fecha_desde, :fecha_hasta, :nromovil_desde, :nromovil_hasta, presence: true
	validates :tipo_informe, inclusion: { in: lambda {|tipo| TipoInforme.map{|k,v| k.to_s}},
							message: "no es un informe válido" }
	validates :nromovil_desde, :nromovil_hasta, numericality: { only_integer: true, 
							greater_than_or_equal_to: 0 }, allow_nil: false

	def initialize(params = nil)
		if params.nil?
			@fecha_desde = Configuracion.current.fecha_proceso
			@fecha_hasta = Configuracion.current.fecha_proceso
			@nromovil_desde = Movil.minimum(:nromovil)
			@nromovil_hasta = Movil.maximum(:nromovil)
		else
	    @tipo_informe = params[:tipo_informe]
	    @fecha_desde = date_from_select_params(params, "fecha_desde")
	    @fecha_hasta = date_from_select_params(params, "fecha_hasta")
	    @nromovil_desde = params[:nromovil_desde]
	    @nromovil_hasta = params[:nromovil_hasta]
	    @mostrar_contrasientos = params[:mostrar_contrasientos]
		end
	end

	def self.tipos_informe
		TipoInforme.map{|k,v| [v, k]}
	end

	def to_s
		"(tipo_informe: #{@tipo_informe}, fecha_desde: #{@fecha_desde}, fecha_hasta: #{@fecha_hasta}, " +
		"nromovil_desde: #{@nromovil_desde}, nromovil_hasta: #{@nromovil_hasta})"
	end

private
	def date_from_select_params(params, field_name)
		Date.new(params["#{field_name}(1i)"].to_i, params["#{field_name}(2i)"].to_i, params["#{field_name}(3i)"].to_i)
	end
end
