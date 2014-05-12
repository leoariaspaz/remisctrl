class CreateTransacciones < ActiveRecord::Migration
  def change
    create_table :transacciones do |t|
      t.string :descripcion
      t.string :sintetico
      t.boolean :es_debito, default: true
      t.boolean :activo, default: true

      t.timestamps
    end
  end
end
