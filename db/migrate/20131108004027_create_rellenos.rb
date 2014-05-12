class CreateRellenos < ActiveRecord::Migration
  def change
    create_table :rellenos do |t|
      t.integer :codigo
      t.string :descripcion
      t.string :sintetico
      t.boolean :habilitado
      t.references :tipo_relleno, index: true

      t.timestamps
    end
  end
end
