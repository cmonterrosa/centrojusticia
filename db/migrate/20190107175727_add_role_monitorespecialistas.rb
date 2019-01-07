class AddRoleMonitorespecialistas < ActiveRecord::Migration
  def self.up
    Role.create(:name => "monitor_especialistas", :descripcion => "monitor de especialistas", :prioridad => 19) unless Role.exists?(:name =>  "monitor_especialistas")
  end

  def self.down
    @jefeconvenios = Role.find_by_name("monitor_especialistas")
    @jefeconvenios.users.delete_all
    Role.find_by_name("monitor_especialistas").destroy if Role.find_by_name("monitor_especialistas")    
  end
end
