class AddRoleEspecialistaExterno < ActiveRecord::Migration
  def self.up
    Role.create(:name => "especialistas_externos", :descripcion => "Especialistas externos", :prioridad => 25) unless Role.exists?(:name =>  "especialistas_externos")
    Role.create(:name => "captura_inicios_externos", :descripcion => "Captura de inicio de trámite foráneos", :prioridad => 26) unless Role.exists?(:name =>  "captura_inicios_externos")
  end

  def self.down
    Role.find_by_name("especialistas_externos").destroy unless Role.exists?(:name =>  "especialistas_externos")
    Role.find_by_name("captura_inicios_externos").destroy unless Role.exists?(:name =>  "captura_inicios_externos")
  end
end
