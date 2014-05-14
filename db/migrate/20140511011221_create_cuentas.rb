class CreateCuentas < ActiveRecord::Migration
  def change
    create_table :cuentas do |t|
      t.references :chofer, index: true
      t.references :movil, index: true
      t.integer :estado
      t.decimal :saldo_anterior, precision: 18, scale: 2

      t.timestamps
    end
    remove_reference :movimientos, :movil, index: true
    remove_reference :movimientos, :chofer, index: true
  end
end
