class CreateSesions < ActiveRecord::Migration
#  def self.up
#    create_table :sesions do |t|
#      t.string :descripcion, :limit => 60
#      t.string :observaciones
#      t.datetime :start_at
#      t.datetime :end_at
#      t.integer :tramite_id
#      t.integer :mediador_id
#      t.integer :comediador_id
#      t.integer :estatus_sesion_id, :default => 1
#    end
#
#    add_index :sesions, [:tramite_id], :name => "tramite"
#    add_index :sesions, [:mediador_id], :name => "mediador"
#    add_index :sesions, [:comediador_id], :name => "comediador"
#    add_index :sesions, [:start_at], :name => "start_at_index"
#  end


    def self.up
    create_table :sesions do |t|
      t.string :observaciones
      t.string :num_tramite, :limit => 9
      t.string :clave, :limit => 6
      t.date :fecha
      
      t.integer :tramite_id
      t.integer :mediador_id
      t.integer :comediador_id
      t.integer :horario_id
      t.integer :estatus_sesion_id
      t.integer :user_id
      t.integer :tiposesion_id
      t.timestamps
    end

    add_index :sesions, [:tramite_id], :name => "tramite"
    add_index :sesions, [:mediador_id], :name => "mediador"
    add_index :sesions, [:comediador_id], :name => "comediador"
    add_index :sesions, [:horario_id], :name => "horario"
    add_index :sesions, [:clave], :name => "clave"
    add_index :sesions, [:tiposesion_id], :name => "tiposesion"
    #add_index :sesions, [:start_at], :name => "start_at_index"
  end



  def self.down
    drop_table :sesions
  end
end
