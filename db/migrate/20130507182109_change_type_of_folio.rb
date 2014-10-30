require 'yaml'
class ChangeTypeOfFolio < ActiveRecord::Migration
  def self.up
    db_yaml = YAML.load_file("#{RAILS_ROOT}/config/database.yml")
    (db_yaml[RAILS_ENV]["adapter"] == "postgresql") ? (change_column :tramites, :folio, 'integer USING CAST(folio AS integer)') : (change_column :tramites, :folio,  :integer)

   #    change_column :tramites, :folio,  :integer
   # change_column :tramites, :folio, 'integer USING CAST(folio AS integer)'

    # Renumber
    counter=1
    Tramite.find(:all, :order => "fechahora").each do |t|
      t.update_attributes!(:folio => counter)
      counter+=1
    end

  end

  def self.down
    change_column(:tramites, :folio,  :string, :limit => 10)
  end
end
