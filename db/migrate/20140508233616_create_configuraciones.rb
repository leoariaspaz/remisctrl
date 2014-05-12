class CreateConfiguraciones < ActiveRecord::Migration
  def change
    create_table :configuraciones do |t|
      t.date :fecha_proceso

      t.timestamps
    end

    Configuracion.create(fecha_proceso: Date.today)
  end
end
