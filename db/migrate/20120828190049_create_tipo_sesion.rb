class CreateTipoSesion < ActiveRecord::Migration
  def self.up
    create_table :tiposesions do |t|
      t.string :descripcion, :limit => 100
    end

    Tiposesion.create(:descripcion => "FIRMA DE CONVENIO")
    Tiposesion.create(:descripcion => "PRIMERA SESION CONJUNTA")
    Tiposesion.create(:descripcion => "SEGUNDA SESION CONJUNTA")
    Tiposesion.create(:descripcion => "TERCERA SESION CONJUNTA")
  end

  def self.down
   drop_table :tiposesions
  end
end
