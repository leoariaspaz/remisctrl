class AddFieldsToChofer < ActiveRecord::Migration
  def change
    add_column :choferes, :credencial, :decimal, scale: 18, precision: 0
    add_column :choferes, :vtocarnet, :date
    add_column :choferes, :direccion, :string
    add_column :choferes, :telefono, :string
    add_column :choferes, :celular, :string
  end
end
