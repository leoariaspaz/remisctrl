module MovilesHelper
	def link_to_moviles_index
		link_to_index title: "Móviles", 
									url: moviles_path, 
									controller:	["moviles", "documentos"]
	end
end
