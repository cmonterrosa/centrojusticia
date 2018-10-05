class CreateTipovisitas < ActiveRecord::Migration
  def self.up
    create_table :tipovisitas do |t|
    	t.string :descripcion
      t.timestamps
    end

    Tipovisita.create(:descripcion => "ORDINARIA") unless Tipovisita.exists?(:descripcion => "ORDINARIA")
    Tipovisita.create(:descripcion => "EXTRAORDINARIA") unless Tipovisita.exists?(:descripcion => "EXTRAORDINARIA")
    Tipovisita.create(:descripcion => "VERIFICACIÓN") unless Tipovisita.exists?(:descripcion => "VERIFICACIÓN")
  end

  def self.down
    drop_table :tipovisitas
  end
end