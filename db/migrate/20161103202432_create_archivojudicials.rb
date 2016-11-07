class CreateArchivojudicials < ActiveRecord::Migration
  def self.up
    create_table :archivojudicials do |t|
      t.column :tramite_id, :integer
      t.column :fecha, :date
      t.column :numero_oficio, :string, :limit => 120
      t.column :observaciones, :string, :limit => 160
      t.column :user_id, :integer
      t.timestamps
    end

    add_index :archivojudicials, [:tramite_id], :name => "archivojudicial_tramite_id"
  end

  def self.down
    drop_table :archivojudicials
  end
end
