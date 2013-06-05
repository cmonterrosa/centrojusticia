class CreateProcedencias < ActiveRecord::Migration
  def self.up
    create_table :procedencias do |t|
      t.string :descripcion, :limit => 150
    end

    Procedencia.create(:descripcion => "JUZGADO DE GARANTÍA Y JUICIO ORAL")
    Procedencia.create(:descripcion => "JUSTICIA RESTAURATIVA")
    Procedencia.create(:descripcion => "CEDH / DIRECCION DE ATENCIÓN A VICTIMAS DE VIOLACIONES A DERECHOS HUMANOS")

  end

  def self.down
    drop_table :procedencias
  end
end
