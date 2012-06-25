class CreateEstatus < ActiveRecord::Migration
  def self.up
    create_table :estatus do |t|
      t.string :descripcion, :limit => 40
      t.string :clave, :limit => 10
      t.integer :secuencia
      t.string :icono, :limit => 30
    end

       #-- load catalogue
    File.open("#{RAILS_ROOT}/db/catalogos/estatus.txt").each do |linea|
        if linea.size > 1
          descripcion, clave, secuencia = linea.split("|")
          Estatu.create(:descripcion => descripcion.strip, :clave=>clave.strip, :secuencia => secuencia.strip)
        end
    end

  end

  def self.down
    drop_table :estatus
  end
end
