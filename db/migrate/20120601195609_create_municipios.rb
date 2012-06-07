class CreateMunicipios < ActiveRecord::Migration
  def self.up
    create_table :municipios do |t|
      t.string :descripcion, :limit => 50
    end

    #-- load catalogue
    File.open("#{RAILS_ROOT}/db/catalogos/municipios.txt").each do |linea|
         Municipio.create(:descripcion => linea.strip)
    end

  end

  def self.down
    drop_table :municipios
  end
end
