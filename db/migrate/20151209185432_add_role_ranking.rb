class AddRoleRanking < ActiveRecord::Migration
  def self.up
    Role.create(:name => "ranking", :descripcion => "Ranking de especialistas", :prioridad => 24) unless Role.exists?(:name =>  "ranking")
  
   ## Migramos atencion al publico y jefeatencionpublico a este nuevo rol ###
    roles = ["atencionpublico", "jefeatencionpublico", "subdireccion", "direccion"]
    @ranking = Role.find_by_name("ranking")
    @usuarios = User.find(:all, :select => "users.*", :joins => "users, roles_users ru, roles r", :conditions => ["users.id=ru.user_id AND ru.role_id=r.id AND users.activo=true AND r.name IN (?)", roles])
    puts "=> Usuarios encontrados"
    @usuarios.each do |u|
      u.roles << @ranking
      puts "=> Agregando Role"
      if u.save
        puts ("#{u.nombre_completo} AGREGADO A ROLE: #{@ranking.name}")
      end
    end
  end

  def self.down
    @ranking = Role.find_by_name("ranking")
    @ranking.users.delete_all
    Role.find_by_name("ranking").destroy unless Role.exists?(:name =>  "ranking")
  end
end
