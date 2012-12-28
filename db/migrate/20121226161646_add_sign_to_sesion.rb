class AddSignToSesion < ActiveRecord::Migration
   def self.up
    #--- Agregamos esas columnas para firmas las sesiones --
    add_column :sesions, :signed_at, :datetime
    add_column :sesions, :signer_id, :integer
  end

  def self.down
    remove_columns(:sesions, :signed_at, :signer_id)
  end
end
