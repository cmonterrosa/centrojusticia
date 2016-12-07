class AddMotivoConclusionImprocedente < ActiveRecord::Migration
  def self.up

     change_column :motivo_conclusions, :fundamento, :string, :limit => 255
     change_column :motivo_conclusions, :causa, :text
     change_column :motivo_conclusions, :resumen, :text

    MotivoConclusion.create(:fundamento => "Artículo 103 fracción II y Artículo 84 del Reglamento",
    :resumen => "Porque el Director General o Subdirector Regional califiquen como improcedente la materia del conflicto en un procedimiento de Justicia Alternativa del Reglamento
La Oficina de Atención al Público turnará a la Oficina de Seguimiento de Convenios de la Subdirección Regional que corresponda las solicitudes para que tramiten ante el titular la calificación del conflicto, y admita o niegue la
admisión, en su caso, la intervención de los especialistas",
   :causa => "materia del conflicto improcedente por no corresponder a la competencia de los tribunales del Estado o por no ser susceptible de resolverse a través de los medios alternativos de solución de controversias") unless MotivoConclusion.exists?(:fundamento => "Artículo 103 fracción II y Artículo 84 del Reglamento")
  end

  def self.down
      MotivoConclusion.find_by_fundamento("Artículo 103 fracción II y Artículo 84 del Reglamento").destroy if MotivoConclusion.exists?(:fundamento => "Artículo 103 fracción II y Artículo 84 del Reglamento").destroy
  end
end
