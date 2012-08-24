class CreateSubdireccions < ActiveRecord::Migration
  def self.up
    create_table :subdireccions do |t|
        t.string :descripcion, :limit => 60
        t.string :titular, :limit => 70
        t.string :direccion, :limit => 120
        t.string :codigo_postal, :limit => 5
        t.string :telefonos, :limit => 40
        t.integer :municipio_id
    end

  # Subdirecciones por defecto
  Subdireccion.create(:descripcion => "Subdirección Regional Centro",
                    :titular => "Lic. Rodrigo Dominguez Moscoso",
                    :direccion => "Calle Candoquis número 290 esq. con Avenida Pino, Fraccionamiento el bosque",
                    :codigo_postal => "29047",
                    :telefonos => "6178700, ext 8863, 8864 y 8865",
                    :municipio_id => Municipio.find_by_descripcion("TUXTLA GUTIERREZ").id)


  Subdireccion.create(:descripcion => "Subdirección Regional Istmo-Costa",
                    :titular => "Lic. Ivan Méndez Soriano",
                    :direccion => "Calle Nube número 280 esq. con Avenida Encino, Fraccionamiento las flores",
                    :codigo_postal => "32047",
                    :telefonos => "6278700, ext 8863, 8864 y 8865",
                    :municipio_id => Municipio.find_by_descripcion("TAPACHULA").id)
end

  
  def self.down
    drop_table :subdireccions
  end
end
