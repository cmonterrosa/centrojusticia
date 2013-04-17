class AnioNac2Participantes < ActiveRecord::Migration
  def self.up
    add_column :participantes, :anio_nac, :string, :limit => 4
  end

  def self.down
    remove_columns(:participantes, :anio_nac)
  end
end
