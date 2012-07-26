class CreateEstatusSesions < ActiveRecord::Migration
  def self.up
    create_table :estatus_sesions do |t|
      t.string :descripcion, :limit => 150
    end

    EstatusSesion.create(:descripcion => "En proceso")
    EstatusSesion.create(:descripcion => "Realizada en tiempo y forma")
    EstatusSesion.create(:descripcion => "No se presento solicitante")
    EstatusSesion.create(:descripcion => "Solo se presento solicitante")
    EstatusSesion.create(:descripcion => "Por mal comportamiento se suspendio sesíón")
    EstatusSesion.create(:descripcion => "Se reprogramo sesión")

  end

  def self.down
    drop_table :estatus_sesions
  end
end
