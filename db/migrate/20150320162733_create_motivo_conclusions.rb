class CreateMotivoConclusions < ActiveRecord::Migration
  def self.up
    create_table :motivo_conclusions do |t|
      t.string :articulo, :integer
      t.string :fraccion, :limit => 8
      t.text :descripcion
    end

    ## Creamos campo en tabla de tramites ###
#     add_column :tramites, :motivo_conclusion_id, :integer
#     add_column :tramites, :observaciones_conclusion, :string

    MotivoConclusion.create(:articulo => 66, :fraccion => "I", :descripcion => "Por convenio o acuerdo por escrito, en el que se hayas resuelto la totalidad o parte de los puntos litigiosos de la controversia")
    MotivoConclusion.create(:articulo => 66, :fraccion => "II", :descripcion => "Por convenio verbal, que deberá constar en actuaciones")
    MotivoConclusion.create(:articulo => 66, :fraccion => "III", :descripcion => "Por el comportamento irrespestuoso o agresivo de alguna de las partes hacia la otra o hacia el especialista, cuya gravedad impida cualquier intento de diálogo posterior")
    MotivoConclusion.create(:articulo => 66, :fraccion => "IV-A", :descripcion => "Por decisión de una parte")
    MotivoConclusion.create(:articulo => 66, :fraccion => "IV-B", :descripcion => "Por decisión de las partes")
    MotivoConclusion.create(:articulo => 66, :fraccion => "V", :descripcion => "Por inasistencia injustificada de una o ambas partes a dos sesiones consecutivas posteriores a la forma del compromiso de participación")
    MotivoConclusion.create(:articulo => 66, :fraccion => "VI", :descripcion => "Por negativa de las partes para la suscripción del acuerdo o convenio en los términos de la presente Ley")
    MotivoConclusion.create(:articulo => 66, :fraccion => "VII", :descripcion => "Por decisión del especialista, cuando la conducta de alguna de las partes, se desprenda indudablemente que no hay voluntad para llegar a un acuerdo")
end

  def self.down
    drop_table :motivo_conclusions
#    remove_columns(:tramites, :motivo_conclusion_id)
#    remove_columns(:tramites, :observaciones_conclusion)
  end
end
