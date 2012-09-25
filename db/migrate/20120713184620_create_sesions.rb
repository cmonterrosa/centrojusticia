class CreateSesions < ActiveRecord::Migration
   def self.up
    create_table :sesions do |t|
        t.string :observaciones
        t.string :resultado, :limit => 120
        t.string :num_tramite, :limit => 9
        t.string :clave, :limit => 6
        t.date :fecha
        t.integer :hora
        t.integer :minutos
        t.integer :sala_id
        t.integer :tramite_id
        t.integer :mediador_id
        t.integer :comediador_id
        t.integer :horario_id
        t.integer :estatus_sesion_id
        t.integer :user_id
        t.integer :tiposesion_id
        t.boolean :activa
        t.boolean :notificacion
        t.timestamps
    end

    add_index :sesions, [:tramite_id], :name => "tramite"
    add_index :sesions, [:mediador_id], :name => "mediador"
    add_index :sesions, [:comediador_id], :name => "comediador"
    add_index :sesions, [:horario_id], :name => "horario"
    add_index :sesions, [:clave], :name => "clave"
    add_index :sesions, [:tiposesion_id], :name => "tiposesion"
    add_index :sesions, [:hora, :minutos, :sala_id], :name => "busqueda_diaria"
    add_index :sesions, [:fecha], :name => "fecha"
  end



  def self.down
    drop_table :sesions
  end
end
