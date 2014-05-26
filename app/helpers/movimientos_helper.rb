module MovimientosHelper
	def td_importe(movimiento)
		# content_tag(:h1, title, class: 'title')
		i = number_to_currency(movimiento.importe)
		cssclass = 'ar'
		if movimiento.es_contrasiento
			cssclass += ' contrasiento'
		end
		content_tag :td, i, class: cssclass
		# <td class="ar <%= %>"><%= number_to_currency movimiento.importe %></td>
	end
end
