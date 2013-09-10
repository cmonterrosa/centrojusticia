class CreateTemporals < ActiveRecord::Migration
  def self.up
    create_table :temporals do |t|
      t.string :numero_expediente, :limit => 20
      t.string :materia_string, :limit => 25
      t.integer :materia_id
      t.timestamps
    end

     Materia.create(:descripcion => "MIXTO") unless Materia.find_by_descripcion("MIXTO")

     #-- load catalogue
    File.open("#{RAILS_ROOT}/db/catalogos/estadisticas.csv").each do |linea|
      expediente, materia = linea.split(",")
      materia_id = Materia.find_by_descripcion(materia.strip)
      materia_id = (materia_id) ? materia_id.id : nil
      t = Temporal.new
      t.numero_expediente = expediente.strip
      t.materia_string = materia
      t.materia_id = materia_id
      if t.save
        puts "=> #{expediente} Registro creado"
      end
    end

  end

  def self.down
    drop_table :temporals
  end
end
