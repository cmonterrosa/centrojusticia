class CreateMecanismoAlternativo< ActiveRecord::Migration
  def self.up
    create_table :mecanismo_alternativos do |t|
      t.column :descripcion, :string, :limit => 30
    end

    Estatu.create(:clave => "meca-asig", :descripcion => "Mecanismo alternativo asignado", :is_default => false, :is_finish => false) unless Estatu.exists?(:clave =>  "meca-asig")

    ### VALORES POR DEFECTO ####
    MecanismoAlternativo.create(:descripcion => "MEDIACION") unless MecanismoAlternativo.exists?(:descripcion => "MEDIACION")
    MecanismoAlternativo.create(:descripcion => "CONCILIACION") unless MecanismoAlternativo.exists?(:descripcion => "CONCILIACION")
    MecanismoAlternativo.create(:descripcion => "ARBITRAJE") unless MecanismoAlternativo.exists?(:descripcion => "ARBITRAJE")
  end

  def self.down
    drop_table :mecanismo_alternativos
    Estatu.find_by_clave("meca-asig").destroy if Estatu.exists?(:clave =>  "meca-asig")
  end
end
