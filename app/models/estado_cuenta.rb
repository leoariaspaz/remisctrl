class EstadoCuenta < ActiveRecord::Base
  ID_RELLENO = 7

  def self.all_for_select
    all.map{|r| [r.descripcion, r.id]}
  end
  
  def self.all_for_validate_inclusion
    all_for_select.map{|e| e[1]}
  end

  def self.all
    Relleno.joins(:tipo_relleno).where("tipos_relleno.codigo = #{ID_RELLENO}").order(:descripcion).load
  end
end
