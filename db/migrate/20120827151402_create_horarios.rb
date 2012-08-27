class CreateHorarios < ActiveRecord::Migration
  def self.up
    create_table :horarios do |t|
      t.integer :hora
      t.string :descripcion, :limit => 100
      t.integer :sala_id
      t.boolean :activo
    end

    #--- Horarios por defecto ---
    Horario.create(:hora => 8, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)
    Horario.create(:hora => 9, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)
    Horario.create(:hora => 10, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)
    Horario.create(:hora => 11, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)

  end

  def self.down
    drop_table :horarios
  end
end
