class CategoriaToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :categoria, :string, :limit => 100
  end

  def self.down
     remove_columns(:users, :categoria)
  end
end
