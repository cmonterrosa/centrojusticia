class CreateFormacions < ActiveRecord::Migration
  def self.up
    create_table :formacions do |t|
      t.integer :empleado_id
      t.integer :institucion_academica_id
      t.integer :estudio_id
      t.integer :user_id
      t.date :fecha_inicial
      t.date :fecha_conclusion
      t.string :observaciones, :limit => "140"
      t.timestamps
    end
    add_index :formacions, [:empleado_id], :name => "Empleado"
  end

  def self.down
    drop_table :formacions
  end
end
