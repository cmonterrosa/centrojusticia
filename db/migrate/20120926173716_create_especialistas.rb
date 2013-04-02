class CreateEspecialistas < ActiveRecord::Migration
  def self.up
    #-- load catalogue
    users = []
    role = Role.find_by_name("ESPECIALISTAS")
    File.open("#{RAILS_ROOT}/db/catalogos/especialistas.txt").each do |linea|
        nombre, apellidos, login = linea.strip.split("|")
        paterno, materno = apellidos.strip.split(" ")
        unless User.find_by_login(login)
           user = User.new(:login => login,
                    :email => "#{login}@correo.com",
                    :password => login.strip,
                    :password_confirmation => login.strip,
                    :paterno => paterno.strip.upcase,
                    :materno => materno.strip.upcase,
                    :nombre => nombre.strip.upcase,
                    :activo => true,
                    :subdireccion_id => 1)
        begin
          user.activation_code = nil
          user.activated_at = Time.now
          user.save
          #user.activate!
        rescue ActiveRecord::RecordInvalid => invalid
          puts invalid.record.errors
        end
        users << user
        end
    end

    #--- Establish role --
    users.each do |user|
          user.roles << role
          user.save
    end
  end

  def self.down
     File.open("#{RAILS_ROOT}/db/catalogos/especialistas.txt").each do |linea|
        nombre, apellidos, login = linea.strip.split("|")
        user = User.find_by_login(login.strip)
        if user
          user.roles = []
          user.save
          user.destroy
        end
        
     end
    
  end
end
