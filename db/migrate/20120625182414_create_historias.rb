class CreateHistorias < ActiveRecord::Migration
  def self.up
    create_table :historias do |t|
      t.integer :tramite_id
      t.integer :estatus_id
      t.integer :user_id
      t.timestamps
    end

    add_index :historias, [:tramite_id], :name => "tramite"
    add_index :historias, [:estatus_id], :name => "estatus"
  end

  def self.down
    drop_table :historias
  end
end
