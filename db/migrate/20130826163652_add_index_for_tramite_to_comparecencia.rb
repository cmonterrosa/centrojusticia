class AddIndexForTramiteToComparecencia < ActiveRecord::Migration
   def self.up
    add_index :comparecencias, [:tramite_id], :name => "tramite_id"
   end

  def self.down
    remove_index(:comparecencias, :tramite_id)
  end
end
