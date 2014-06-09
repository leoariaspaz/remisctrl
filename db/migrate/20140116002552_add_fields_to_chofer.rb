class AddFieldsToChofer < ActiveRecord::Migration
  def change
  	reversible do |dir|
  		dir.up do
		  	change_table :choferes do |t|
			    t.decimal	:credencial, :decimal, precision: 18, scale: 0
			    t.date 		:vtocarnet, :date
			    t.string 	:direccion, :telefono, :celular
		  	end
  		end
  		dir.down do
		  	change_table :choferes do |t|
		    	t.remove :credencial, :vtocarnet, :direccion, :telefono, :celular
		  	end
  		end
  	end
  end
end
