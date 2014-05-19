class CreateConfiguraciones < ActiveRecord::Migration
  def change
    create_table :configuraciones do |t|
      t.date :fecha_proceso

      t.timestamps
    end
  end
end
