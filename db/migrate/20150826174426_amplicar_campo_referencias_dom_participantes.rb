class AmplicarCampoReferenciasDomParticipantes < ActiveRecord::Migration
  def self.up
    change_column :participantes, :referencia_domiciliaria, :string, :limit => 300
  end

  def self.down
    change_column :participantes, :referencia_domiciliaria, :string, :limit => 160
  end
end
