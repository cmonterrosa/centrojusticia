class CreateEstatus < ActiveRecord::Migration
  def self.up
    create_table :estatus do |t|
      t.string :descripcion, :limit => 40
    end
    Estatu.create(:descripcion => "Activa")
    Estatu.create(:descripcion => "En espera")
    Estatu.create(:descripcion => "Finalizado")
  end

  def self.down
    drop_table :estatus
  end
end
