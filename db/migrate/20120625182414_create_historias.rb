class CreateHistorias < ActiveRecord::Migration
  def self.up
    create_table :historias do |t|
      t.integer :tramite_id
      t.integer :estatu_id
      t.integer :user_id
      t.timestamps
    end

    add_index :historias, [:tramite_id], :name => "historias_tramite"
    add_index :historias, [:estatu_id], :name => "historias_estatus"
  end

  def self.down
    drop_table :historias
  end
end
