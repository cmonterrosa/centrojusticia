class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
      t.string :descripcion, :limit => 40
      t.integer :prioridad
    end

    # roles por defecto
    Role.create(:name => "consejo", :descripcion => "Consejo de la Judicatura", :prioridad => 1)
    Role.create(:name => "admin", :descripcion => "Administrador global", :prioridad => 2)
    Role.create(:name => "direccion", :descripcion => "Dirección General", :prioridad => 3)
    Role.create(:name => "subdireccion", :descripcion => "Subdirección Regional", :prioridad => 4)
    Role.create(:name => "jefeatencionpublico", :descripcion => "Jefatura de área de Atención al público", :prioridad => 5)
    Role.create(:name => "atencionpublico", :descripcion => "Area de Atención al público", :prioridad => 6)
    Role.create(:name => "especialistas", :descripcion => "Especialistas públicos", :prioridad => 7)
    Role.create(:name => "invitadores", :descripcion => "Invitadores", :prioridad => 8)
    Role.create(:name => "reportes", :descripcion => "Reportes", :prioridad => 9)
    Role.create(:name => "convenios", :descripcion => "Área de convenios", :prioridad => 10)
    Role.create(:name => "solicitantes", :descripcion => "Solicitantes", :prioridad => 11)
    Role.create(:name => "invitados", :descripcion => "Invitados", :prioridad => 12)
     # generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"
  end

  def self.down
    drop_table "roles"
    drop_table "roles_users"
  end
end