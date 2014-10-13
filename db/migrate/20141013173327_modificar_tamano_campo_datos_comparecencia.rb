class ModificarTamanoCampoDatosComparecencia < ActiveRecord::Migration
  def self.up
    change_column :comparecencias, :datos, :string, :limit => 140
  end

  def self.down
    change_column :comparecencias, :datos, :string, :limit => 60
  end
end
