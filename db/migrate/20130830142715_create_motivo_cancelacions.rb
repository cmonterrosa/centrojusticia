class CreateMotivoCancelacions < ActiveRecord::Migration
  def self.up
    create_table :motivo_cancelacions do |t|
      t.string :descripcion, :limit => 120
    end

    MotivoCancelacion.create(:descripcion => "ERROR DE CAPTURA")
    MotivoCancelacion.create(:descripcion => "INFORMACION INCOMPLETA O INSUFICIENTE")
    MotivoCancelacion.create(:descripcion => "POR SOLICITUD PERSONAL")
    MotivoCancelacion.create(:descripcion => "OTRA")
  end

  def self.down
    drop_table :motivo_cancelacions
  end
end
