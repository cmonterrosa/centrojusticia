class IndexSearchTramite < ActiveRecord::Migration
  def self.up
    add_index :orientacions, [:tramite_id, :nombre, :paterno], :name => "search_nombre"
  end

  def self.down
    remove_index(:orientacions, :search_nombre)
  end
end
