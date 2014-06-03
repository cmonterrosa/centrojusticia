class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracions do |t|
      t.string :hora_cambio_turno, :limit => 15
      t.string :pie_pagina, :limit => 120
    end
  end

  def self.down
    drop_table :configuracions
  end
end
