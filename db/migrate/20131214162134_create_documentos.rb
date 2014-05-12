class CreateDocumentos < ActiveRecord::Migration
  def change
    create_table :documentos do |t|
    	t.belongs_to :movil
    	t.belongs_to :tipo_imagen
      t.string :imagen      

      t.timestamps
    end
  end
end
