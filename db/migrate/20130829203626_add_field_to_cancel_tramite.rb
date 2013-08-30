class AddFieldToCancelTramite < ActiveRecord::Migration
  def self.up
    add_column :tramites, :motivo_cancelacion_id, :integer
    add_column :tramites, :cancelacion_observaciones, :string, :limit => 120

    #### Creamos estatus ####
    Estatu.create(:clave => "tram-canc", :descripcion => "Trámite cancelado") unless Estatu.find_by_clave("tram-canc")

    #### Creamos rol para cancelar trámites ####
    Role.create(:name => "cancelatramite", :descripcion => "Cancelación de trámites") unless Role.find_by_name("cancelatramite")

  end

  def self.down
    remove_columns(:tramites, :motivo_cancelacion_id)
    remove_columns(:tramites, :cancelacion_observaciones)
    ### Borramos registros ###
    Estatu.find_by_clave("tram-canc").destroy if Estatu.find_by_clave("tram-canc")
    Role.find_by_name("cancelatramite").destroy if Role.find_by_name("cancelatramite")
  end
end
