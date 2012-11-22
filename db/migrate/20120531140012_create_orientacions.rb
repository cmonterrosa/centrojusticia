class CreateOrientacions < ActiveRecord::Migration
  def self.up
    create_table :orientacions do |t|
      t.datetime :fechahora
      t.string :observaciones
      t.integer :user_id
      t.integer :sala_id
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :nombre, :limit => 60
      t.string :sexo, :limit => 1
      t.string :direccion, :limit => 60
      t.string :telefono, :limit => 10
      t.string :correo, :limit => 40
      t.integer :municipio_id
      t.integer :tramite_id
      t.boolean :notificacion
      t.integer :especialista_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orientacions
  end
end
