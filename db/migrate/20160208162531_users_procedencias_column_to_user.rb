class UsersProcedenciasColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :procedencia_id, :integer
  end

  def self.down
    remove_column :users, :procedencia_id
  end
end
