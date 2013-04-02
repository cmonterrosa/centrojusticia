class CreateParticipantes < ActiveRecord::Migration
  def self.up
    create_table :participantes do |t|
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :nombre, :limit => 60
      t.date :fecha_nac
      t.string :sexo, :limit => 1
      t.string :domicilio
      t.string :telefono_particular, :limit => 10
      t.string :telefono_celular, :limit => 10
      t.string :correo, :limit => 30
      # relacion con otras tablas
      t.integer :municipio_id
      t.integer :user_id
      t.integer :comparecencia_id
      t.timestamps
    end
  end

  def self.down
    drop_table :participantes
  end
end
