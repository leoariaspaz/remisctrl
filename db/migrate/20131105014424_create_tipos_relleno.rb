class CreateTiposRelleno < ActiveRecord::Migration
  def change
    create_table :tipos_relleno do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
