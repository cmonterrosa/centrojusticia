class AddIndextoNombre < ActiveRecord::Migration
 def self.up
    add_index :orientacions, [:nombre, :tramite_id], :name => "busqueda_nombre"
  end

  def self.down
    remove_index(:orientacions, :busqueda_nombre)
  end
end
