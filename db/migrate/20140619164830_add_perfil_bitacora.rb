class AddPerfilBitacora < ActiveRecord::Migration
  def self.up
    Role.create(:name => "asignahorario", :descripcion => "Asignacion de horarios", :prioridad => 18) unless Role.find_by_name("asignahorario")
    Role.create(:name => "bitacora", :descripcion => "Ver bitacora de atencion", :prioridad => 19) unless Role.find_by_name("bitacora")

  end

  def self.down
    Role.find_by_name("asignahorario").destroy if Role.find_by_name("asignahorario")
    Role.find_by_name("bitacora").destroy if Role.find_by_name("bitacora")
  end
end
