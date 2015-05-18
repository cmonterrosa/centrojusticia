class CreatePais < ActiveRecord::Migration
  def self.up
    create_table :pais do |t|
      t.string :clave, :limit => 2
      t.string :descripcion, :limit => 100
    end
     add_column :orientacions, :pais_id, :integer
     add_column :participantes, :pais_id, :integer
     add_index :pais, :clave, :unique => true
      File.open("#{RAILS_ROOT}/db/catalogos/paises.csv").each do |linea|
      clave,descripcion = linea.strip.split(",")
      Pais.create(:clave => clave.strip, :descripcion => descripcion.strip)
      end
  end

  def self.down
    drop_table :pais
     remove_index(:orientacions, :pais_id)
     remove_index(:participantes, :pais_id)
  end
end
