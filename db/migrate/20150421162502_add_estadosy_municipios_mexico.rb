class AddEstadosyMunicipiosMexico < ActiveRecord::Migration
  def self.up
    # Creamos tabla de estados de la republica
    create_table :estados do |t|
      t.integer :pais_id
      t.string :descripcion, :limit => 40
    end

     add_index :estados, :descripcion, :unique => true
     add_column :municipios, :estado_id, :integer
     add_index :municipios, [:estado_id], :name => "municipios_estado"

    contador=0
    mexico = Pais.find_by_clave("MX")
    File.open("#{RAILS_ROOT}/db/catalogos/estados_municipios.txt").each do |linea|
      estado, municipio, lada = linea.split(",")

      if (estado.strip == 'CHIAPAS')
         puts("Es municipio de Chiapas")
         municipio_chiapas = (Municipio.find_by_descripcion(municipio))? Municipio.find_by_descripcion(municipio) : Municipio.new(:descripcion => municipio)
         chiapas = (Estado.find_by_descripcion("CHIAPAS")) ?  Estado.find_by_descripcion("CHIAPAS") : Estado.create(:descripcion => "CHIAPAS", :pais_id => mexico.id)
         puts("=> Coincidencia encontrada: #{municipio_chiapas.descripcion}")
         municipio_chiapas.update_attributes(:estado_id => chiapas.id) if chiapas && municipio
         municipio_chiapas.save if chiapas && municipio
         
      else
        # Creamos a las demas entidades federativas
        nuevo_estado = (Estado.find_by_descripcion(estado)) ?  Estado.find_by_descripcion(estado) : Estado.create(:descripcion => estado, :pais_id => mexico.id)
        municipio = Municipio.new(:descripcion => municipio, :estado_id => nuevo_estado.id)
        municipio.save if nuevo_estado#&& puts("=> #{municipio.descripcion} del estado de #{nuevo_estado.descripcion} Creado")
        contador+=1
      end
    end

    ### Si existen registro de extranjeros ###
#    if extranjero = Estado.find_by_descripcion("EXTRANJERO")
#      Municipio.create(:descripcion =>"GUATEMALA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"EL SALVADOR", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"HONDURAS", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"NICARAGUA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"CARIBE", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"SUDAMÉRICA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"NORTEAMERICA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"UNION EUROPEA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"ASIA", :estado_id => extranjero.id )
#      Municipio.create(:descripcion =>"ÁFRICA", :estado_id => extranjero.id )
#    end


     puts("=> Total coincidencias de otros estados: #{contador}")

  end

  def self.down
    drop_table :estados
    remove_index(:municipios, :estado_id)
    remove_columns(:municipios, :estado_id)
  end
end
