class CreateEstatus < ActiveRecord::Migration
  def self.up
    create_table :estatus do |t|
      t.string :descripcion, :limit => 40
      t.string :clave, :limit => 10
      #---- tipo ---
      t.boolean :is_default
      t.boolean :is_finish
    end

    #-- load catalogue
    File.open("#{RAILS_ROOT}/db/catalogos/estatus.txt").each do |linea|
        if linea.size > 1
          descripcion, clave, is_default, is_finish = linea.split("|")
          Estatu.create(:descripcion => descripcion.strip, :clave=>clave.strip, :is_default => is_default.strip, :is_finish => is_finish.strip)
        end
    end

    #--- creamos la tabla para vincularlos con los roles ----
     create_table "estatus_roles", :id => false do |t|
      t.integer "role_id", "estatu_id"
    end

    #---- indices ----
    add_index "estatus_roles", "role_id"
    add_index "estatus_roles", "estatu_id"
    add_index :estatus, [:clave], :name => "clave_estatus"
  end

  def self.down
    drop_table :estatus
    drop_table :estatus_roles
  end
end
