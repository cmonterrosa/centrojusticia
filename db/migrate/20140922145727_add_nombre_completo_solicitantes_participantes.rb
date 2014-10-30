class AddNombreCompletoSolicitantesParticipantes < ActiveRecord::Migration
  def self.up
      add_column :orientacions, :full_name, :string, :limit => 70
      add_column :participantes, :full_name, :string, :limit => 70

      ### Actualizamos registros ###
      @orientaciones = Orientacion.find(:all)
      contador=0
      puts("=> ORIENTACIONES")
      @orientaciones.each do |o|
        paterno=(o.paterno)? o.paterno.strip : ""
        materno=(o.materno)? o.materno.strip : ""
        nombre=(o.nombre)? o.nombre.strip : ""
        if paterno.size > 0
          if o.update_attributes!(:full_name => "#{nombre} #{paterno} #{materno}")
            puts("#{contador}.-  #{o.full_name} - CREADO")
            contador+=1
          else
            puts("#{o.id} NO CREADO")
          end
        end
      end
      puts ("=> Total registros: #{contador}")

    @participantes = Participante.find(:all)
     contador=0
    puts("=> PARTICIPANTES")
      @participantes.each do |p|
        paterno=(p.paterno)? p.paterno.strip : ""
        materno=(p.materno)? p.materno.strip : ""
        nombre=(p.nombre)? p.nombre.strip : ""
        if paterno.size > 0
          if p.update_attributes!(:full_name => "#{nombre} #{paterno} #{materno}")
             puts("#{contador}.-  #{p.full_name} - CREADO")
             contador+=1
          else
            puts("#{p.id} NO CREADO")
          end
        end
      end

    add_index :orientacions, [:full_name], :name => "orientacions_nombre_completo"
    add_index :participantes, [:full_name], :name => "participantes_nombre_completo"
  end

  def self.down
    remove_columns(:orientacions, :full_name)
    remove_columns(:participantes, :full_name)
  end
end
