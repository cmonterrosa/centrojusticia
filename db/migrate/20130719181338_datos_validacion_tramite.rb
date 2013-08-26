class DatosValidacionTramite < ActiveRecord::Migration
   def self.up
    add_column :tramites, :procedente, :boolean
    add_column :tramites, :objeto_solicitud, :string, :limit => 140
    add_column :tramites, :observaciones_generales, :string
    add_column :tramites, :documentacion_anexa, :string, :limit => 160
  end

  def self.down
    remove_columns(:tramites, :procedente)
    remove_columns(:tramites, :objeto_solicitud)
    remove_columns(:tramites, :observaciones_generales)
    remove_columns(:tramites, :documentacion_anexa)
  end  
end
