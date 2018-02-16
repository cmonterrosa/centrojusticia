class AddManifestacion < ActiveRecord::Migration
 def self.up
  	ManifestacionSeguimiento.create(:clave => "FINAL", :descripcion => "FINALIZADO") unless ManifestacionSeguimiento.find_by_clave("FINAL")
  end

  def self.down
  	ManifestacionSeguimiento.find_by_clave("FINAL").destroy if ManifestacionSeguimiento.find_by_clave("FINAL")
  end  
end
