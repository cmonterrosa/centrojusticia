class AddSituacionLactancia < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :numero_oficio, :string, :limit => 60
  end

  def self.down
    remove_column :movimientos, :numero_oficio
  end
end
