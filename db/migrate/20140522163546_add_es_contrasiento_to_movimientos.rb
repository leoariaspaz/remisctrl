class AddEsContrasientoToMovimientos < ActiveRecord::Migration
  def change
    add_column :movimientos, :es_contrasiento, :boolean
  end
end
