class ModifySizeOfSubrieccionsDireccion < ActiveRecord::Migration
  def self.up
    change_column(:subdireccions, :direccion, :string, :limit => 250)
    change_column(:configuracions, :pie_pagina, :string, :limit => 250)
  end

  def self.down
  end
end
