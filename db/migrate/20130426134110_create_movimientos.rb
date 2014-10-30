class CreateMovimientos < ActiveRecord::Migration

  def self.up
    create_table :movimientos do |t|
      t.integer :situacion_id
      t.integer :user_id
      t.integer :autorizo
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.string :observaciones, :limit => 220
      t.timestamps
    end

    add_index :movimientos, [:user_id], :name => "movimientos_usuario"
    add_index :movimientos, [:situacion_id], :name => "movimientos_situacion"
  end

  def self.down
    drop_table :movimientos
  end
end
