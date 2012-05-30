class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
      t.string :descripcion, :limit => 40
    end

    # roles por defecto
    Role.create(:name => "consejo", :descripcion => "Consejo de la Judicatura")
    Role.create(:name => "admin", :descripcion => "Administrador global")
    Role.create(:name => "direccion", :descripcion => "Dirección General")
    Role.create(:name => "subdireccion", :descripcion => "Subdirección Regional")
    Role.create(:name => "jefeatencionpublico", :descripcion => "Jefatura de área de Atención al público")
    Role.create(:name => "atencionpublico", :descripcion => "Area de Atención al público")
    Role.create(:name => "especialistas", :descripcion => "Especialistas públicos")
    Role.create(:name => "invitadores", :descripcion => "Invitadores")
    Role.create(:name => "especialistas", :descripcion => "Especialistas públicos")
    Role.create(:name => "reportes", :descripcion => "Reportes")
    Role.create(:name => "convenios", :descripcion => "Área de convenios")
    Role.create(:name => "solicitantes", :descripcion => "Solicitantes")
    Role.create(:name => "invitados", :descripcion => "Invitados")
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