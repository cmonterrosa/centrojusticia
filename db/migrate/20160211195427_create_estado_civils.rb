class CreateEstadoCivils < ActiveRecord::Migration
  def self.up
    create_table :estado_civils do |t|
      t.column :descripcion, :string, :limit => 80
    end
    add_column :participantes, :estado_civil_id, :integer

    #### CREAMOS CATALOGO DE ESTADOS CIVILES ###
    EstadoCivil.create(:descripcion => "SOLTERO(A)") unless EstadoCivil.exists?(:descripcion => "SOLTERO(A)")
    EstadoCivil.create(:descripcion => "CASADO(A)") unless EstadoCivil.exists?(:descripcion => "CASADO(A)")
    EstadoCivil.create(:descripcion => "DIVORCIADO(A)") unless EstadoCivil.exists?(:descripcion => "DIVORCIADO(A)")
    EstadoCivil.create(:descripcion => "VIUDO(A)") unless EstadoCivil.exists?(:descripcion => "VIUDO(A)")
    EstadoCivil.create(:descripcion => "SE DESCONOCE") unless EstadoCivil.exists?(:descripcion => "SE DESCONOCE")
  end

  def self.down
    drop_table :estado_civils
  end
end
