class CreateEmpleados < ActiveRecord::Migration
  def self.up
    create_table :empleados do |t|
      t.string :enlace, :limit => 6
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :nombre, :limit => 60
      t.string :categoria, :limit => 60
      t.string :sexo, :limit => 1
      t.date :fecha_nac
      t.string :observaciones, :limit => 100
      t.date :fecha_ingreso
      t.boolean :baja
      t.date :fecha_baja
      ## Relaciones con otras tablas ##
      t.timestamps
    end
    add_column :users, :empleado_id, :integer

    ### Por defecto a los especialistas los creamos como empleados ###
    Role.find_by_name("especialistas").todos_usuarios.each { |u|
    @e = Empleado.new(:paterno => u.paterno,
                                   :materno => u.materno,
                                   :nombre => u.nombre,
                                   :categoria => u.categoria,
                                   :sexo => u.sexo)
    u.update_attributes!(:empleado_id => @e.id) if @e.save
    }

  end

  def self.down
    drop_table :empleados
     remove_columns(:users, :empleado_id)
  end
end
