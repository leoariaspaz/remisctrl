class CreateMovimientos < ActiveRecord::Migration
  def change
    create_table :movimientos do |t|
      t.references :transaccion, index: true
      t.date :fecha_movimiento
      t.date :fecha_proceso
      t.string :observacion
      t.decimal :importe, precision: 18, scale: 2
      t.references :movil, index: true
      t.references :chofer, index: true

      t.timestamps
    end
  end
end
