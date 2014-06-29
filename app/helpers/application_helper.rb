module ApplicationHelper
	# Fuente: http://apidock.com/rails/v3.2.13/ActionView/Helpers/FormTagHelper/select_tag
	def select_options_tag(name='',select_options={},options={})
		#set selected from value
		selected = ''
		unless options[:value].blank?
		  selected = options[:value]
		  options.delete(:value)
		end
		select_tag(name, options_for_select(select_options,selected), options)
	end

	def render_notice(msg)
		if msg
			content_tag(:p, content_tag(:span, msg), id: "notice")
		else
			content_tag(:p, "", id: "notice")
		end
	end
	
	# Crea botones para los formularios de ABM
	def form_actions(cancel_url = "")
		content = submit_tag('Grabar', class: 'btnsave')
		if cancel_url != ""
			content += link_to('Cancelar', cancel_url)
		end
		content_tag(:div, content, class: "actions")
	end	

	# Crea botones para los formularios de búsqueda
	def search_actions(cancel_url = "")
		content = submit_tag('Consultar', class: 'btnsearch')
		if not cancel_url.blank?
			content += link_to('Cancelar', cancel_url)
		end
		content_tag(:div, content, class: "actions")
	end
	
	def render_error(an_entity, an_entity_name)
		render partial: 'app/error_messages', locals: {entity: an_entity, entity_name: an_entity_name}
	end
	
	def format_date(date)
		date.strftime('%d/%m/%Y') if date
	end
	
	def content_title
		content_for(:title) ||	(params[:action] + ' ' + params[:controller])
	end
	
	def set_title(title)
		content_for(:title) { title }
		content_tag(:h1, title, class: 'title')
	end

	def link_to_action(text, path, html_options = {})
		html_options[:class] = ((html_options[:class])? html_options[:class] : "") + ' btnaction'
		link_to text, path, html_options
	end
	
	def link_to_new(text, path)
		link_to text, path, class: 'btnaction btnadd'
	end
	
	def link_to_index(options)
		#c = ["propietarios"]
		#if params[:controller] == 'documentos' and params.has_key?(:propietario_id)
		#	c << "documentos"
		#end
		#link_to_index model_name: "propietario", url: propietarios_path, controller:	c



		model_name   = options[:model_name]	|| ""
		title        = options[:title] || model_name.titleize.pluralize
		controller   = options[:controller] || model_name.pluralize
		url          = options[:url] || url_for(controller: controller, action: "index")
		html_options = options[:html_options] || {}
		parent_of 	 = options[:parent_of] || {}
		model_as_key = "#{model_name}_id".to_sym
		if controller.kind_of?(String)
			all_controllers = [controller]
		else
			all_controllers = controller
		end
		if parent_of.kind_of?(String)
			parent_of = [parent_of]
		end
		if (parent_of.include?(request[:controller]) and params.has_key?(model_as_key)) or
					all_controllers.include?(request[:controller])
			html_options.reverse_merge!({class: 'current'})
		end

		# if controller.kind_of?(String)
		# 	html_options.reverse_merge!({class: 'current'})	if request[:controller] == controller
		# elsif controller.kind_of?(Array)
		# 	html_options.reverse_merge!({class: 'current'}) if controller.include? request[:controller]
		# end
		link_to title, url, html_options
	end
	
	def link_to_edit(path)
  	link_to path do
			image_tag "pencil.png", alt: "editar", title: "editar"
    end
	end

	def link_to_delete(path, title = 'eliminar', msg = t('helpers.destroy.confirm'))
  	link_to path, method: :delete, data: { confirm: msg } do
			image_tag "trash.png", alt: 'eliminar', title: title
    end	
	end

	def link_to_print(url_for_options = {}, img_options = {})
		url_for_options.reverse_merge!({action: "print", format: "pdf"})
		link_to url_for(url_for_options) do
    	image_tag "printer.png", img_options
    end
	end

	def logs_estado_pagination(logs_estado, model_name)
		will_paginate logs_estado, page_links: false, params: { controller: 'logs_estado', action: 'index',
				model_name: model_name }
	end

	def format_cuenta(cuenta)
		"%07d" % cuenta
	end
end
