class AddDescripcionToCuentas < ActiveRecord::Migration
  def change
    add_column :cuentas, :descripcion, :string
  end
end
