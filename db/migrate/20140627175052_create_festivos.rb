class CreateFestivos < ActiveRecord::Migration
  def self.up
    create_table :festivos do |t|
      t.column :fecha_inicio, :datetime
      t.column :fecha_fin, :datetime
      t.column :descripcion, :string, :limit => 160
      t.column :user_id, :integer
      t.timestamps
    end
    add_index :festivos, [:fecha_inicio, :fecha_fin], :name => "fechas"
  end

  def self.down
    remove_index(:festivos, :fecha)
    drop_table :festivos
  end
end
