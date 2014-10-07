class CreateEstudios < ActiveRecord::Migration
  def self.up
    create_table :estudios do |t|
      t.integer :parent_id
      t.string :descripcion
      t.boolean :valor_curricular
      t.integer :nivel_academico_id
    end
    add_index :estudios, [:parent_id], :name => "Padre"
end

  def self.down
    drop_table :estudios
  end
end
