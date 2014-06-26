class AddRoleControlInvitaciones < ActiveRecord::Migration
   def self.up
    Role.create(:name => "controlinvitaciones", :descripcion => "Control de invitaciones", :prioridad => 20) unless Role.find_by_name("controlinvitaciones")
   end

  def self.down
    Role.find_by_name("controlinvitaciones").destroy if Role.find_by_name("controlinvitaciones")
  end
end
