class AddContrasientoToMovimientos < ActiveRecord::Migration
  def change
  	change_table :movimientos do |t|
    	t.column :es_contrasiento, :boolean, default: false
    	t.column :fecha_contrasiento, :datetime, null: true
  	end
  end
end
