class CreateJustificacions < ActiveRecord::Migration
  def self.up
    create_table :justificacions do |t|
      t.string :descripcion, :limit => 120
    end
    
    Justificacion.create(:descripcion => "ESPECIALISTA EN SESIÓN")
    Justificacion.create(:descripcion => "ESPECIALISTA NO BAJO EN TIEMPO")
    Justificacion.create(:descripcion => "ESPECIALISTA AUSENTE")
    Justificacion.create(:descripcion => "ESPECIALISTA EN ATENCION EXTRAORDINARIA")
    Justificacion.create(:descripcion => "ESPECIALISTA NO DA ATENCIÓN")
    Justificacion.create(:descripcion => "DESCONOCIDA")
  end

  def self.down
    drop_table :justificacions
  end
end
