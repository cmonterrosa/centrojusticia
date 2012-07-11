class CreateTipodocs < ActiveRecord::Migration
  def self.up
    create_table :tipodocs do |t|
      t.string :descripcion, :limit => 100
    end

    #--- Catalogo por defecto ---
    Tipodoc.create(:descripcion => "COPIA DE ACTA DE NACIMIENTO")
    Tipodoc.create(:descripcion => "COPIA DE ACTA DE MATRIMONIO")
    Tipodoc.create(:descripcion => "COPIA DE ACTA DE DEFUNCION")
    Tipodoc.create(:descripcion => "COPIA DE CREDENCIAL DE ELECTOR")
    Tipodoc.create(:descripcion => "COPIA DE FACTURA AUTOMOTRIZ")
    Tipodoc.create(:descripcion => "COPIA DE SENTENCIA")
  end

  def self.down
    drop_table :tipodocs
  end
end
