class AddNewFieldstoParticipantes < ActiveRecord::Migration
  def self.up
      add_column :participantes, :perfil, :string, :limit=>20
      add_column :participantes, :telefono_celular_aux, :string, :limit=>20
      add_column :participantes, :tipopersona_id, :integer
      add_column :participantes, :referencia_domiciliaria, :string, :limit => 160
      add_column :participantes, :razon_social, :string, :limit => 160
   end

  def self.down
      remove_columns(:participantes, :perfil)
      remove_columns(:participantes, :telefono_celular_aux)
      remove_columns(:participantes, :tipopersona_id)
      remove_columns(:participantes, :referencia_domiciliaria)
      remove_columns(:participantes, :razon_social)
  end
end
