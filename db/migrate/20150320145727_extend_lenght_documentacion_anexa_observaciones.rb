class ExtendLenghtDocumentacionAnexaObservaciones < ActiveRecord::Migration
  def self.up
    change_column(:tramites, :documentacion_anexa,  :text)
    change_column(:tramites, :observaciones_generales, :text)
  end

  def self.down
    change_column(:tramites, :documentacion_anexa,  :string)
    change_column(:tramites, :observaciones_generales, :string)
  end
end
