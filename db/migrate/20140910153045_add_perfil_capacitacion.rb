class AddPerfilCapacitacion < ActiveRecord::Migration
  def self.up
    Role.create(:name => "capacitacion", :descripcion => "Capacitacion de personal", :prioridad => 21) unless Role.find_by_name("capacitacion")
  end

  def self.down
    Role.find_by_name("capacitacion").destroy if Role.find_by_name("capacitacion")
  end
end
