class CreateHorarios < ActiveRecord::Migration
  def self.up
    create_table :horarios do |t|
      t.integer :hora
      t.integer :minutos
      t.string :descripcion, :limit => 100
      t.integer :sala_id
      t.boolean :activo
    end

    #--- Horarios por defecto ---
    Horario.create(:hora => 8, :minutos => 0, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)
    Horario.create(:hora => 8,  :minutos => 0, :descripcion => "Primera sesion", :sala_id => 2, :activo => true)
    Horario.create(:hora => 8, :minutos => 0, :descripcion => "Primera sesion", :sala_id => 3, :activo => true)
    Horario.create(:hora => 9, :minutos => 30, :descripcion => "Segunda sesión", :sala_id => 1, :activo => true)
    Horario.create(:hora => 10, :minutos => 0, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)
    Horario.create(:hora => 10, :minutos => 0, :descripcion => "Primera sesion", :sala_id => 2, :activo => true)
    Horario.create(:hora => 11,:minutos => 0, :descripcion => "Primera sesion", :sala_id => 1, :activo => true)

  end

  def self.down
    drop_table :horarios
  end
end
