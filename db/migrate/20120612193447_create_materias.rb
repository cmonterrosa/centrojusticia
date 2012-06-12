class CreateMaterias < ActiveRecord::Migration
  def self.up
    create_table :materias do |t|
      t.string :descripcion, :limit => 60
    end

    Materia.create(:descripcion => "CIVIL")
    Materia.create(:descripcion => "PENAL")
    Materia.create(:descripcion => "MERCANTIL")
    Materia.create(:descripcion => "FISCAL")
    Materia.create(:descripcion => "OTRA")
  end

  def self.down
    drop_table :materias
  end
end
