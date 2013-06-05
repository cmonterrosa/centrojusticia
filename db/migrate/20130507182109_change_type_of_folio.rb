class ChangeTypeOfFolio < ActiveRecord::Migration
  def self.up
    change_column(:tramites, :folio,  :integer)

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
