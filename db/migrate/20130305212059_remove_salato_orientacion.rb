class RemoveSalatoOrientacion < ActiveRecord::Migration
  def self.up
     remove_columns(:orientacions, :sala_id)
  end
 

  def self.down
     add_column :orientacions, :sala_id, :integer
  end
end
