class AddPerfilLibroControl < ActiveRecord::Migration
  def self.up
    Role.create(:name => "librocontrol", :descripcion => "Consulta de libro de control", :prioridad => 18) unless Role.exists?(:name =>  "librocontrol")
  end

  def self.down
    if @librocontrols = Role.find_by_name("librocontrol")
      @librocontrols.users.delete_all
      Role.find_by_name("librocontrol").destroy unless Role.exists?(:name =>  "librocontrol")
    end
  end
end
