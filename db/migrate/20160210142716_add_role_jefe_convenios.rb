class AddRoleJefeConvenios < ActiveRecord::Migration
  def self.up
    Role.create(:name => "jefeconvenios", :descripcion => "Jefe del área de convenios", :prioridad => 17) unless Role.exists?(:name =>  "jefeconvenios")
  end

  def self.down
    @jefeconvenios = Role.find_by_name("jefeconvenios")
    @jefeconvenios.users.delete_all
    Role.find_by_name("jefeconvenios").destroy unless Role.exists?(:name =>  "jefeconvenios")
  end
end
