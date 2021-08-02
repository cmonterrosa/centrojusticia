class AddColumnEtapaIdToComparecencias < ActiveRecord::Migration
  def self.up
    add_column :comparecencias, :etapa_id, :integer unless Comparecencia.column_names.include?("etapa_id")
  end

  def self.down
    remove_column :comparecencias, :etapa_id
  end
end
