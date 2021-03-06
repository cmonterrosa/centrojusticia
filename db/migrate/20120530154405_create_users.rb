class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login,                     :limit => 40
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.datetime :last_login
      #--- datos personales ----
      t.column :nombre,                      :string, :limit => 100, :default => '', :null => true
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :direccion, :limit => 120
      t.integer :tel_celular
      t.integer :subdireccion_id
      t.boolean :activo
      t.boolean :admin, :default => false
    end

    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
