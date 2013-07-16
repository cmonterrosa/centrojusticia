class AddIndexToFlujos < ActiveRecord::Migration
  def self.up
    add_index :flujos, [:old_status_id, :role_id], :name => "busqueda_role"
  end

  def self.down
    remove_index(:flujos, :busqueda_role)
  end
end
