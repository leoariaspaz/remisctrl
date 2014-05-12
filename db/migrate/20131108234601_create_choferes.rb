class CreateChoferes < ActiveRecord::Migration
  def change
    create_table :choferes do |t|
      t.string :nombre
      t.string :apodo
      t.references :estado
      t.date :fechaestado

      t.timestamps
    end
  end
end
