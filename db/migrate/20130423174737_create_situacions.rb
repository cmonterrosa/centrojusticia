class CreateSituacions < ActiveRecord::Migration
  def self.up
    create_table :situacions do |t|
      t.string :descripcion, :limit => 60
    end

    #---- Create the foreign column ---
    add_column :users, :situacion_id, :integer

    #--- Create the index for make the query faster
    add_index :users, [:situacion_id], :name => "situacion"

    #-- Load the default catalogue
    positive = Situacion.create(:descripcion => "DISPONIBLE")
    Situacion.create(:descripcion => "PERMISO")
    Situacion.create(:descripcion => "EN SESION")
    Situacion.create(:descripcion => "EN LICENCIA")
    Situacion.create(:descripcion => "EN GUARDIA")

    # Establish the default status for all users
    User.find(:all).each do |u| u.update_attributes!(:situacion_id => positive.id) end
  end

  def self.down
    drop_table :situacions
    remove_index(:users, :situacion_id)
    remove_columns(:users, :situacion_id)
  end
end
