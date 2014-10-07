class CompleteEmpleadosTable < ActiveRecord::Migration


  def self.up
      add_column :empleados, :institucion, :string, :limit => 100
      add_column :empleados, :correo, :string, :limit => 40
      add_column :empleados, :direccion, :string, :limit => 140
      add_column :empleados, :codigo_postal, :string, :limit => 10
      add_column :empleados, :telefono, :string, :limit => 40
      add_column :empleados, :telefono_celular, :string, :limit => 14
      add_column :empleados, :notas, :text, :limit => 500
      add_column :empleados, :subdireccion_id, :integer
      add_column :empleados, :municipio_id, :integer
     
      #### Procesamiento de datos ####
      #usuario	Organización	Apellidos	Nombre	Dirección de correo electrónico	Especialidad	Teléfono	Teléfono móvil	Dirección	Ciudad	Codigo Postal	Notas
      #hjimenez,Poder Judicial del Esatado de Chiapas,Jiménez Esponda,Héctor Ivan,hijes2009@hotmail.com,Director General,Centro,---,9615791283,Cerrada Amarantos # 1 Fracc. Los Laureles.,Tuxtla Gutiérrez,2902
      @subdireccion  = Subdireccion.find_by_descripcion('Subdirección Regional Centro')
      @municipio = (@subdireccion.municipio)? (@subdireccion.municipio) : (Municipio.find_by_descripcion("TUXTLA GUTIERREZ"))
      File.open("#{RAILS_ROOT}/db/catalogos/empleados_ceja.csv").each_line { |line|
      usuario,organizacion,apellidos,nombre,correo,categoria,region,telefono,celular,direccion,codigo_postal = line.split(",")
      begin
        puts usuario.strip
        @usuario = User.find(:first, :conditions => ["login = ?", usuario.strip])
        if @usuario
           @empleado = (@usuario.empleado) ? @usuario.empleado : Empleado.find(:first, :conditions => ["nombre = ?", nombre.strip])
           if @empleado 
             puts(@empleado.nombre_completo)
             @empleado.update_attributes( :institucion => "Poder Judicial del Estado de Chiapas",
                                                            :correo => correo.strip,
                                                            :direccion => direccion.strip,
                                                            :codigo_postal => codigo_postal.strip,
                                                            :telefono => telefono.strip,
                                                            :categoria => categoria.strip,
                                                            :telefono_celular => celular.strip,
                                                            :municipio_id => @municipio.id,
                                                            :subdireccion_id => @subdireccion.id
                                                            )
              puts("=> Actualizado:  #{nombre} - #{apellidos}") if @empleado.save
           else
              # Creamos empleado
              puts("------- #{usuario} No encontrado")
                                  @empleado = Empleado.new(:institucion => "Poder Judicial del Estado de Chiapas",
                                                            :correo => correo.strip,
                                                            :direccion => direccion.strip,
                                                            :codigo_postal => codigo_postal.strip,
                                                            :telefono => telefono.strip,
                                                            :categoria => categoria.strip,
                                                            :telefono_celular => celular.strip,
                                                            :municipio_id => @municipio.id,
                                                            :subdireccion_id => @subdireccion.id,
                                                            :nombre => nombre.strip,
                                                            :paterno => apellidos.strip
                                                            )
                                   if @empleado.save
                                      @usuario.empleado = @empleado
                                      puts("=> Creado:  #{nombre} - #{apellidos}") if @usuario.save
                                   end


           end

        else
            puts("No existe usuario")
        end
        

      rescue => e
        puts e
      end
      }

  end

  def self.down
    remove_columns(:empleados, :institucion)
    remove_columns(:empleados, :correo)
    remove_columns(:empleados, :direccion)
    remove_columns(:empleados, :codigo_postal)
    remove_columns(:empleados, :telefono)
    remove_columns(:empleados, :telefono_celular)
    remove_columns(:empleados, :notas)
    remove_columns(:empleados, :subdireccion_id)
    remove_columns(:empleados, :municipio_id)
  end




end # cierra clase