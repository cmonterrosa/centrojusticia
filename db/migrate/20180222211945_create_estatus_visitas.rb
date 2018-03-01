class CreateEstatusVisitas < ActiveRecord::Migration
  def self.up
    create_table :estatus_visitas do |t|
    	t.string :descripcion
      t.timestamps
    end

    EstatusVisita.create(:descripcion => "INICIADA") unless EstatusVisita.exists?(:descripcion => "INICIADA")
    EstatusVisita.create(:descripcion => "CONCLUIDA") unless EstatusVisita.exists?(:descripcion => "CONCLUIDA")
    EstatusVisita.create(:descripcion => "REVISADA") unless EstatusVisita.exists?(:descripcion => "REVISADA")
  end

  def self.down
    drop_table :estatus_visitas
  end
end
