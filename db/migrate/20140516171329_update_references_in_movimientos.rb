class UpdateReferencesInMovimientos < ActiveRecord::Migration
  def change
  	change_table :movimientos do |t|
	    t.remove_references :movil, index: true
	    t.remove_references :chofer, index: true
	    t.references :cuenta, index: true
  	end
  end
end
