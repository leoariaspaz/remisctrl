class CreateMoviles < ActiveRecord::Migration
  def change
    create_table :moviles do |t|
      t.integer :nromovil
      t.string :marca
      t.integer :modelo
      t.string :dominio
      t.references :estado, index: true
      t.date :fecha_estado
      t.references :agencia, index: true
      t.references :propietario, index: true
      t.references :chofer, index: true

      t.timestamps
    end
  end
end
