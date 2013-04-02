class AddOnlyOrientacionFieldToTramite < ActiveRecord::Migration
  def self.up
    add_column :tramites, :only_orientacion, :boolean
  end

  def self.down
    remove_columns(:tramites, :only_orientacion)
  end
end

