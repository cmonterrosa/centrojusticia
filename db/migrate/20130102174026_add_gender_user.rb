class AddGenderUser < ActiveRecord::Migration

  def self.up
      add_column :users, :sexo, :string, :limit => 1
  end

  def self.down
      remove_columns(:users, :sexo)
  end
end
