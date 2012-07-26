class CreateSesions < ActiveRecord::Migration
  def self.up
    create_table :sesions do |t|
      t.string :descripcion, :limit => 60
      t.string :observaciones
      t.datetime :start_at
      t.datetime :end_at
      t.integer :tramite_id
      t.integer :mediador_id
      t.integer :comediador_id
      t.integer :estatus_sesion_id, :default => 1
    end

    add_index :sesions, [:tramite_id], :name => "tramite"
    add_index :sesions, [:mediador_id], :name => "mediador"
    add_index :sesions, [:comediador_id], :name => "comediador"
  end

  def self.down
    drop_table :sesions
  end
end
