class CreateSalas < ActiveRecord::Migration
  def self.up
    create_table :salas do |t|
      t.string :descripcion, :limit => 30
      t.integer :capacidad
      t.boolean :is_active, :default => true
      t.integer :subdireccion_id
    end

    Sala.create(:descripcion => "SALA DE SESIONES A", :capacidad => 4, :subdireccion_id => 1)
    Sala.create(:descripcion => "SALA DE SESIONES B", :capacidad => 2, :subdireccion_id => 1)
    Sala.create(:descripcion => "SALA DE SESIONES C", :capacidad => 5, :subdireccion_id => 1)
    Sala.create(:descripcion => "SALA DE SESIONES D", :capacidad => 3, :subdireccion_id => 1)
    Sala.create(:descripcion => "SALA DE SESIONES E", :capacidad => 3, :subdireccion_id => 1)
  end

  def self.down
    drop_table :salas
  end
end
