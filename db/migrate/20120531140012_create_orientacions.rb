class CreateOrientacions < ActiveRecord::Migration
  def self.up
    create_table :orientacions do |t|
      t.datetime :fechahora
      t.string :observaciones
      t.integer :user_id
      t.integer :sala_id
      t.string :paterno
      t.string :materno
      t.string :nombre
      t.string :sexo
      t.string :direccion, :limit => 60
      t.string :telefono, :limit => 10
      t.string :correo, :limit => 40
      t.integer :municipio_id
      t.integer :estatu_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orientacions
  end
end
