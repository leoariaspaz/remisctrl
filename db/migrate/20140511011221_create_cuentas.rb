class CreateCuentas < ActiveRecord::Migration
  def change
    create_table :cuentas do |t|
      t.references :chofer, index: true
      t.references :movil, index: true
      t.integer :estado_id
      t.decimal :saldo_anterior, precision: 18, scale: 2, default: 0

      t.timestamps
    end
  end
end
