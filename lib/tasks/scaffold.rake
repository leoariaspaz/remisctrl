namespace :scaffold do
  desc "Adapta un scaffold ya generado al formato de la aplicación"
  task :adapt, [:model] => :environment do |t, args|
 	  args.with_defaults(:model => "")
  	if args.model.empty?
  		puts "Sintaxis incorrecta: No se indicó un nombre de modelo"
  		puts "Se esperaba:\n\trake scaffold:adapt[model]"
  		next
  	end
  	model = args.model
  	delete_files model.pluralize
  	replace_controller model.pluralize
  	replace_view(model, "new", "Nuevo")
  	replace_view(model, "edit", "Editando")
  	replace_view(model, "index")
  	replace_view(model, "_form")
  end
end

def delete_files(model)
	path = "#{Rails.root}/app/views/#{model}/*.json.jbuilder"
	puts "Eliminando vistas #{model}/*.json.jbuilder"
	Dir.glob(path) { |f| File.delete(f) }

	puts "Eliminando vista #{model}/show.html.erb"
	f = "#{Rails.root}/app/views/#{model}/show.html.erb"
	File.delete(f) if File.exists?(f)
end

def replace_controller(model)
	f = File.open("#{Rails.root}/app/controllers/#{model}_controller.rb", "a+")

	puts "Reemplazando referencias a json en #{model}_controller"
	s = f.read.gsub /\s.+(format)?\.json.*/, ""

	puts "Localizando mensaje 'created'"
	rgx = /redirect_to.+'.+created*.'/
	replacement = "redirect_to #{model.pluralize}_url, notice: t('scaffold.save_msg', entity: \"\#{@#{model.singularize}}\")"
	s.gsub! rgx, replacement

	puts "Localizando mensaje 'updated'"
	rgx = /redirect_to.+'.+updated*.'/
	replacement = "redirect_to #{model.pluralize}_url, notice: t('scaffold.update_msg', entity: \"\#{@#{model.singularize}}\")"
	s.gsub! rgx, replacement

	f.truncate(0)
	f.write s
	f.close
end

def replace_view(model, view, title = nil)
	puts "Reemplazando texto en views/#{model.pluralize}/#{view}.html.erb"
	f = File.open("#{Rails.root}/app/views/#{model.pluralize}/#{view}.html.erb", "a+")
	s = f.read
	if view == "index"
		replacement = "<%= set_title \"#{model.titleize.pluralize}\" %>\n\n" +
									"<div class=\"btnbar\">\n\t" + 
									"<%= link_to_new 'Nuevo #{model}', new_#{model}_path %>\n" +
									"</div>\n\n" + 
									"<%= render_notice notice %>"
		s.gsub! %r{<h1>.+#{model.pluralize}</h1>}, replacement
		s[%r{.+<th></th>\n}] = ""
		s.gsub! /\<br\/?\>.+link_to 'New.+/m, ""
		s.gsub! /<table>/, '<table class="data">'
		s.gsub! /.+link_to 'Show.+\n/, ""
		s.gsub! /><%= link_to 'Edit',/, %q{ class="action"><%= link_to_edit}
		s.gsub! /><%= link_to 'Destroy'.+/, %Q{ class=\"action\"><%= link_to_delete #{model} %></td>}
	elsif view == "_form"
		s.gsub! /<% if(.+?end %>){2}/m, "<%= render_error @#{model}, 'El #{model}' %>"
		s.gsub! /<div class="actions">.+?<\/div>/m, "<%= form_actions(#{model.pluralize}_path) %>"
	else
		s.gsub! /\<h1\>.+#{model}\<\/h1\>/, "<%= set_title \"#{title} #{model}\" %>"
		s.gsub! /.+link_to.+/, ""
	end
	s.strip!
	f.truncate(0)
	f.write s
	f.close
end
