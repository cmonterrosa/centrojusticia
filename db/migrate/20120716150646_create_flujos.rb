class CreateFlujos < ActiveRecord::Migration
  def self.up
    create_table :flujos do |t|
      t.integer :old_status_id
      t.integer :new_status_id
      t.integer :role_id
      t.string :descripcion
      t.timestamps
    end
  end

  def self.down
    drop_table :flujos
  end
end
