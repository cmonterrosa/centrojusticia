class AmpliarCampoObservacionesCancelTramite < ActiveRecord::Migration
   def self.up
    change_column :tramites, :cancelacion_observaciones, :string, :limit => 220
  end

  def self.down
    change_column :tramites, :cancelacion_observaciones, :string, :limit => 120
  end
end
