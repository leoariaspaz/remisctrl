class CreateDerechos < ActiveRecord::Migration
  def change
    create_table :derechos do |t|
      t.string :nombre
      t.string :controller
      t.string :action

      t.timestamps
    end
  end
end
