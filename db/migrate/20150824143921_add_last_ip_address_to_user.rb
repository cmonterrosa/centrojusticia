class AddLastIpAddressToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :last_ip, :string, :limit => 15
  end

  def self.down
    remove_columns(:users, :last_ip)
  end
end
