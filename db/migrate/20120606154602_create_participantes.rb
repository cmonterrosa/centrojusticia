class CreateParticipantes < ActiveRecord::Migration
  def self.up
    create_table :participantes do |t|
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :nombre, :limit => 60
      t.date :fecha_nac
      t.string :sexo, :limit => 1
      t.string :domicilio, :limit => 100
      t.string :telefono_particular, :limit => 10
      t.string :telefono_celular, :limit => 10
      t.string :correo, :limit => 30
      # relacion con otras tablas
      t.integer :municipio_id
      t.integer :user_id
      t.timestamps
    end

   create_table :comparecencias_participantes, :id => false do |t|
      t.integer :participante_id
      t.integer :comparecencia_id
    end

  end

  def self.down
    drop_table :participantes
    drop_table :comparecencias_participantes
  end
end
