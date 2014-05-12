class CreateUsuariosRolesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :usuarios, :roles do |t|
      # t.index [:usuario_id, :rol_id]
      t.index [:rol_id, :usuario_id], unique: true
    end
  end
end
