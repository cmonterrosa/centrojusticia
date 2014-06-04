class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracions do |t|
      t.string :hora_cambio_turno, :limit => 15
      t.string :pie_pagina, :limit => 120
    end

    Configuracion.create(:hora_cambio_turno => "15:55", :pie_pagina => "") if Configuracion.find(:all).empty?

  end

  def self.down
    drop_table :configuracions
  end
end
