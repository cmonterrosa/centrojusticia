class AddCancelLogtoSesion < ActiveRecord::Migration
  def self.up
     add_column :sesions, :cancel, :integer
     add_column :sesions, :cancel_user, :integer
  end

  def self.down
    remove_columns(:sesions, :cancel)
    remove_columns(:sesions, :cancel_user)
  end
end
