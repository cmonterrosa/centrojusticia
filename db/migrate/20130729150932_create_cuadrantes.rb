class CreateCuadrantes < ActiveRecord::Migration
 def self.up
    create_table :cuadrantes do |t|
      t.string :descripcion, :limit => 150
      t.integer :subdireccion_id
    end

    create_table :cuadrantes_users, :id => false do |t|
      t.integer :cuadrante_id
      t.integer :user_id
    end
    add_column :participantes, :cuadrante_id, :integer
  end

  def self.down
    drop_table :cuadrantes
    drop_table :cuadrantes_users
    remove_columns(:participantes, :cuadrante_id)
  end
end
