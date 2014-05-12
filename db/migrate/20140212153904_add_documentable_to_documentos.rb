class AddDocumentableToDocumentos < ActiveRecord::Migration
  def change
    add_reference :documentos, :documentable, polymorphic: true, index: true
    remove_reference :documentos, :movil
  end
end
