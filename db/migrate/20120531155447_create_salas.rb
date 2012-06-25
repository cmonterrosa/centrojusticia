class CreateSalas < ActiveRecord::Migration
  def self.up
    create_table :salas do |t|
      t.string :descripcion, :limit => 40
      t.integer :capacidad
      t.boolean :activo, :default => true
    end

    Sala.create(:descripcion => "Primera Sala", :capacidad => 4)
    Sala.create(:descripcion => "Segunda Sala", :capacidad => 2)
    Sala.create(:descripcion => "Tercera Sala", :capacidad => 5)
    Sala.create(:descripcion => "Cuarta Sala", :capacidad => 3)
  end

  def self.down
    drop_table :salas
  end
end
