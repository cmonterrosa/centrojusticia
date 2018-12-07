class CreateTipoparticipantevisitas < ActiveRecord::Migration
  def self.up
    if !table_exists?("tipoparticipantevisitas")
      create_table :tipoparticipantevisitas do |t|
      	t.string :descripcion
        t.timestamps
      end
    end

    Tipoparticipantevisita.create(:descripcion => "MAGISTRADO VISITADOR") unless Tipoparticipantevisita.exists?(:descripcion => "MAGISTRADO VISITADOR")
    Tipoparticipantevisita.create(:descripcion => "AUXILIAR") unless Tipoparticipantevisita.exists?(:descripcion => "AUXILIAR")
  end

  def self.down
    drop_table :tipoparticipantevisitas
  end
end
