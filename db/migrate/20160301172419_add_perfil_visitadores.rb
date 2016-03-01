class AddPerfilVisitadores < ActiveRecord::Migration
  def self.up
    Role.create(:name => "visitadores", :descripcion => "Personal de visitaduria", :prioridad => 27) unless Role.exists?(:name =>  "visitadores")
  end

  def self.down
    if @visitadores = Role.find_by_name("visitadores")
      @visitadores.users.delete_all
      Role.find_by_name("visitadores").destroy unless Role.exists?(:name =>  "visitadores")
    end
  end
end
