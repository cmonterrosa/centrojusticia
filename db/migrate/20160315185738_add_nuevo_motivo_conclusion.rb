class AddNuevoMotivoConclusion < ActiveRecord::Migration
  def self.up
    unless MotivoConclusion.exists?(:fundamento =>  "Artículo 56, segundo párrafo de la ley" )
      MotivoConclusion.create(:fundamento => "Artículo 56, segundo párrafo de la ley",
      :causa => "Porque la otra parte involucrada se negó expresamente a someterse a los mecanismos alternativos de solución de controversias.",
      :resumen => "Porque la otra parte involucrada se negó expresamente a someterse a los mecanismos alternativos de solución de controversias.")
    end
  end

  def self.down
    if MotivoConclusion.exists?(:fundamento =>  "Artículo 56, segundo párrafo de la ley" )
      MotivoConclusion.find_by_fundamento("Artículo 56, segundo párrafo de la ley").destroy
    end
  end
end
