class AddFechaExpiracionHorariosSesiones < ActiveRecord::Migration
  def self.up
      add_column :horarios, :fecha_inicio, :date
      add_column :horarios, :fecha_expiracion, :date
      add_index :horarios, [:activo, :fecha_inicio, :fecha_expiracion], :name => "horarios_fechas"
      Horario.reset_column_information
     # Establecemos fecha de inicio de los horarios, al 1 de enero de 2013  y fin 31 de diciembre de 9999###
     Horario.all.each do |h|
       if h.update_attributes!(:fecha_inicio => DateTime.parse("1-01-2013"), :fecha_expiracion => DateTime.parse("31-12-9999") )
          puts("=> #{h.descripcion_completa} GUARDADO") if h.descripcion
       end
     end

  end

  def self.down
      remove_column :horarios, :fecha_expiracion
      remove_column :horarios, :fecha_inicio
      remove_index :horarios, :horarios_fechas
  end
end
