class CambioDescripcionProcesoConvenios < ActiveRecord::Migration
  def self.up
    Estatu.find_by_clave("proc-conv").update_attributes!(:descripcion=>"Convenio cargado") if Estatu.find_by_clave("proc-conv")
  end

  def self.down
    puts ("=> No tiene accion reversiva")
  end
end
