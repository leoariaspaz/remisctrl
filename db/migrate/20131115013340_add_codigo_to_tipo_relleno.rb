class AddCodigoToTipoRelleno < ActiveRecord::Migration
  def change
    add_column :tipos_relleno, :codigo, :integer
  end
end
