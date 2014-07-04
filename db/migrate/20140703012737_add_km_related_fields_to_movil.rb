class AddKmRelatedFieldsToMovil < ActiveRecord::Migration
  def change
  	change_table :moviles do |t|
  		t.integer 	:km_recorridos, default: 0
  		t.datetime 	:km_recorridos_hasta, default: DateTime.now
  		t.integer		:ultimo_cambio_embrague_km, default: 0
  		t.datetime	:fecha_cambio_embrague, null: true
  		t.integer		:ventana_cambio_embrague_km, default: 0
  		t.integer		:ultimo_cambio_correa_dist_km, default: 0
  		t.datetime	:fecha_cambio_correa_dist, null: true
  		t.integer		:ventana_cambio_correa_dist_km, default: 0
  	end
  end
end
