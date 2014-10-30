class CreateExtraordinarias < ActiveRecord::Migration
  def self.up
    create_table :extraordinarias do |t|
      t.string :delito, :limit => 120
      t.string :num_expediente, :limit => 25
      t.string :termino, :limit => 25
      t.string :num_oficio, :limit => 25
      t.string :observaciones, :limit => 180
      t.datetime :fechahora
      t.string :paterno, :limit => 40
      t.string :materno, :limit  => 40
      t.string :nombre, :limit => 60
      t.string :sexo, :limit => 1
      t.integer :procedencia_id
      t.integer :user_id
      t.integer :especialista_id
      t.integer :tramite_id
      t.boolean :notificacion
      t.timestamps
    end
    add_index :extraordinarias, [:procedencia_id], :name => "extraordinarias_procedencia"
    add_index :extraordinarias, [:num_expediente], :name => "extraordinarias_numero_expediente"
    add_index :extraordinarias, [:tramite_id], :name => "extraordinarias_tramites"
  end

  def self.down
     remove_index(:extraordinarias, :procedencia)
     remove_index(:extraordinarias, :num_expediente)
     remove_index(:extraordinarias, :tramites)
     drop_table :extraordinarias
  end
end
