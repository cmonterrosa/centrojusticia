class AddFolioExpedienteToTramite < ActiveRecord::Migration
  def self.up
     add_column :tramites, :folio_expediente, :integer
  end

  def self.down
    remove_columns(:tramites, :folio_expediente)
  end                                         
end
