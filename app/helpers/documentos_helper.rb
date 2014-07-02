module DocumentosHelper
	def link_to_print_documentos(d)
		if d.documentos.any?
			url_for_options = polymorphic_path([:print_documentos, d], format: :pdf)
			img_options = {}
			link_to_print(url_for_options, img_options, "Imprimir documentos")
		end
	end
end
