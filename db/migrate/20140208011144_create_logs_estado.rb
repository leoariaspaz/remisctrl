class CreateLogsEstado < ActiveRecord::Migration
  def change
    create_table :logs_estado do |t|
      t.string :motivo
      t.integer :estado_id
      t.references :estado_loggeable, polymorphic: true

      t.timestamps
    end

    add_index 	:logs_estado, ["estado_loggeable_id", "estado_loggeable_type"], 
    			unique: false, name: "idx_logs_estado_polymorphic"
  end
end
