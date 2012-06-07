class CreateComparecencias < ActiveRecord::Migration
  def self.up
    create_table :comparecencias do |t|
      t.datetime :fechahora
      t.string :procedencia, :limit => 40
      t.string :caracter, :limit => 40
      t.integer :hora_preferencia
      t.integer :dia_preferencia
      t.boolean :conocimiento
      t.string :datos, :limit => 60
      t.text :asunto, :limit => 512
      t.string :observaciones
      #--relaciones con otras tablas
      t.integer :user_id
      t.integer :orientacion_id
      t.timestamps
    end
    
   add_index :comparecencias, [:user_id], :name => "user"

  end

  def self.down
    remove_index :comparecencias, :name => "user"
    drop_table :comparecencias
  end
end
