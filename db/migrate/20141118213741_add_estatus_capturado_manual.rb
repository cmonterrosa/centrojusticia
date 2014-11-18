class AddEstatusCapturadoManual < ActiveRecord::Migration
  def self.up
    Estatu.create(:clave => "tram-hist", :descripcion => "Trámite histórico capturado") unless Estatu.find_by_clave("tram-hist")
  end

  def self.down
    Estatu.find_by_name("tram-hist").destroy if Estatu.find_by_clave("tram-hist")
  end
end
