class CreateEtapas < ActiveRecord::Migration
  def self.up
    if !table_exists?("etapas")
      create_table :etapas do |t|
      	t.string :clave
        t.string :descripcion
        t.timestamps
      end
    end

    Etapa.create(:clave => "proc", :descripcion => "PROCESO") unless Etapa.exists?(:clave => "proc")
    Etapa.create(:clave => "ejec", :descripcion => "EJECUCIÓN DE SENTENCIAS") unless Etapa.exists?(:clave => "ejec")

  end

  
  def self.down
    drop_table :etapas
  end
end
