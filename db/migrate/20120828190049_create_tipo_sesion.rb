class CreateTipoSesion < ActiveRecord::Migration
  def self.up
    create_table :tiposesions do |t|
      t.string :descripcion, :limit => 40
    end
    Tiposesion.create(:descripcion => "RESERVA DE SESION")
    Tiposesion.create(:descripcion => "ORIENTACION CONJUNTA")
    Tiposesion.create(:descripcion => "SESION CONSECUTIVA")
    Tiposesion.create(:descripcion => "FORMA DE CONVENIO")
    Tiposesion.create(:descripcion => "MODIFICACION DE CONVENIO")
  end

  def self.down
   drop_table :tiposesions
  end
end
