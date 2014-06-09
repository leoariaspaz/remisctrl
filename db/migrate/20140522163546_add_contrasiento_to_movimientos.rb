class AddContrasientoToMovimientos < ActiveRecord::Migration
  def change
  	reversible do |dir|
  		dir.up do
		  	change_table :movimientos do |t|
		    	t.boolean :es_contrasiento, default: false
		    	t.datetime :fecha_contrasiento, :datetime, null: true
		  	end  			
  		end
  		dir.down do
		  	change_table :movimientos do |t|
		    	t.remove :es_contrasiento, :fecha_contrasiento
		  	end
  		end
  	end
  end
end
