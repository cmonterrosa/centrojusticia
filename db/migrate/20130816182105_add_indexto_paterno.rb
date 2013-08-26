class AddIndextoPaterno < ActiveRecord::Migration
  def self.up
    add_index :orientacions, [:paterno, :tramite_id], :name => "busqueda_paterno"
  end

  def self.down
    remove_index(:orientacions, :busqueda_paterno)
  end
end
