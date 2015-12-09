class AddMecanismoAlternativo < ActiveRecord::Migration
  def self.up
    add_column :tramites, :mecanismo_alternativo_id, :integer
    add_index :tramites, [:mecanismo_alternativo_id], :name => "tramites_mecanismo_alternativo"
  end

  def self.down
    remove_columns :tramites, :mecanismo_alternativo_id
    remove_index :tramites, :tramites_mecanismo_alternativo
  end
end
