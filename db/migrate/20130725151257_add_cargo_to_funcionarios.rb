class AddCargoToFuncionarios < ActiveRecord::Migration
  def self.up
     add_column :subdireccions, :cargo, :string, :limit => 120
  end

  def self.down
    remove_columns(:subdireccions, :cargo)
  end
end
