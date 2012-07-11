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


    create_table "materias_users", :id => false do |t|
      t.integer "user_id", "materia_id"
    end

    add_index "materias_users", "user_id"
    add_index "materias_users", "materia_id"

  end

  def self.down
    drop_table :materias
    drop_table :materias_users
  end
end
