class AddPerfilAdminUsers < ActiveRecord::Migration
  def self.up
    Role.create(:name => "adminusuarios", :descripcion => "Administracion de usuarios", :prioridad => 22) unless Role.find_by_name("adminusuarios")
  end

  def self.down
    Role.find_by_name("adminusuarios").destroy if Role.find_by_name("adminusuarios")
  end
end
