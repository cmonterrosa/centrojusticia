class AddIndexHistorias < ActiveRecord::Migration
  def self.up
    add_index :historias, [:tramite_id, :estatu_id, :user_id], :name => "Historial"
  end

  def self.down
    remove_index(:historias, :historial)
  end
end
