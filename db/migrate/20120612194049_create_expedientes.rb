class CreateExpedientes < ActiveRecord::Migration
  def self.up
    create_table :expedientes do |t|
      t.integer :folio
      t.integer :anio
      t.datetime :fechahora
      #-- relacion con otras tablas --
      t.integer :materia_id
      t.integer :comparecencia_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :expedientes
  end
end
