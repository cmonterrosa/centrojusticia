class AddIndexBusquedaMovimientos < ActiveRecord::Migration
  def self.up
    add_index :movimientos, [:user_id, :fecha_inicio, :fecha_fin], :name => "movimientos_busqueda"
  end

  def self.down
    remove_index(:movimientos, :busqueda)
  end
end
