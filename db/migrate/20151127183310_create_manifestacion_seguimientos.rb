class CreateManifestacionSeguimientos < ActiveRecord::Migration
  def self.up
    create_table :manifestacion_seguimientos do |t|
      t.column :clave, :string, :limit => 5
      t.column :descripcion, :string, :limit => 60
    end

    ##### CREAMOS CATALOGO ########
    ManifestacionSeguimiento.create(:clave => "NOCON", :descripcion => "NO SE ENCONTRÓ O NO LO CONOCEN EN EL LUGAR")
    ManifestacionSeguimiento.create(:clave => "FUSER", :descripcion => "NUMERO TELEFÓNICO FUERA DEL AREA DE SERVICIO O BUZON")
    ManifestacionSeguimiento.create(:clave => "NONUM", :descripcion => "NO EXISTE NÚMERO TELEFONICO O HA SIDO CAMBIADO")
    ManifestacionSeguimiento.create(:clave => "NOTOM", :descripcion => "NO TOMÓ LA LLAMADA")
    ManifestacionSeguimiento.create(:clave => "NOINT", :descripcion => "NO LE INTERESA")
    ManifestacionSeguimiento.create(:clave => "SICUM", :descripcion => "SI ESTA COMPLIENDO TOTALMENTE")
    ManifestacionSeguimiento.create(:clave => "NOCUM", :descripcion => "NO ESTA COMPLIENDO TOTALMENTE")
    ManifestacionSeguimiento.create(:clave => "NSBNR", :descripcion => "NO SABE O NO RESPONDIO")
    ManifestacionSeguimiento.create(:clave => "OTROS", :descripcion => "OTRO MOTIVO")
  end

  def self.down
    drop_table :manifestacion_seguimientos
  end
end
