class CreateLactancias < ActiveRecord::Migration
  def self.up
    create_table :lactancias do |t|
      t.column :user_id, :integer
      t.column :fecha_inicio, :date
      t.column :fecha_fin, :date
      t.column :horario_inicio, :time
      t.column :horario_fin, :time
      t.column :numero_oficio, :string, :limit => 60
      t.column :autorizo, :integer
      t.column :observaciones, :string, :limit => 120
      t.column :activa, :boolean
      t.timestamps
    end
    add_index :lactancias, [:user_id], :name => "lactancias_user"
  end

  def self.down
    drop_table :lactancias
  end
end
