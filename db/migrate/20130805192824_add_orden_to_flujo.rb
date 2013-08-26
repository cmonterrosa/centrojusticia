class AddOrdenToFlujo < ActiveRecord::Migration
 def self.up
    add_column :flujos, :orden, :integer
  end

  def self.down
    remove_columns(:flujos, :orden)
  end
end
