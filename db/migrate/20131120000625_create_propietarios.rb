class CreatePropietarios < ActiveRecord::Migration
  def change
    create_table :propietarios do |t|
      t.string :nombre
      t.integer :nrodoc
      t.references :tipo_doc, index: true
      t.date :fecha_alta
      t.references :estado, index: true
      t.date :fecha_estado

      t.timestamps
    end
  end
end
