class CreateRolesDerechosJoinTable < ActiveRecord::Migration
  def change
    create_join_table :roles, :derechos do |t|
      # t.index [:rol_id, :derecho_id]
      t.index [:derecho_id, :rol_id], unique: true
    end
  end
end
