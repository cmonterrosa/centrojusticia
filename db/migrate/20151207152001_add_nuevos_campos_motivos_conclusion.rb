class AddNuevosCamposMotivosConclusion < ActiveRecord::Migration
  def self.up
    remove_columns(:motivo_conclusions, :integer)
    remove_columns(:motivo_conclusions, :articulo)
    remove_columns(:motivo_conclusions, :fraccion)
    remove_columns(:motivo_conclusions, :descripcion)
    add_column :motivo_conclusions, :fundamento, :string, :limit => 160
    add_column :motivo_conclusions, :causa, :string
    add_column :motivo_conclusions, :resumen, :string, :limit => 220
    add_column :motivo_conclusions, :created_at, :datetime
    add_column :motivo_conclusions, :updated_at, :datetime
    add_index :motivo_conclusions, [:fundamento], :name => "motivo_conclusiones_fundamento"

    File.open("#{RAILS_ROOT}/db/catalogos/motivos_conclusion.csv").each do |linea|
      fundamento, causa,resumen,identificador = linea.strip.split("|")
      if identificador
          motivo = MotivoConclusion.find(identificador)
          motivo.update_attributes(:fundamento => fundamento.strip,
                                                 :causa => causa.strip, :created_at => Time.now,
                                                 :resumen => resumen.strip) if motivo
          puts ("=> Motivo: #{motivo.resumen} creado") if motivo && motivo.save
      else
          motivo = MotivoConclusion.new(:fundamento => fundamento.strip,
                                                            :causa => causa.strip,
                                                            :resumen => resumen.strip)
          puts ("=> Motivo: #{motivo.resumen} creado") if motivo.save
      end
      end

     ### Ajuste final ####
     @concluidos_inciso_letra = Concluido.find(:all, :conditions => ["motivo_conclusion_id = ?", 5])
     @concluidos_inciso_letra.each do |c|
       c.update_attributes!(:motivo_conclusion_id => 4)
     end
     @concluido_inciso_letra = MotivoConclusion.find(5)
     @concluido_inciso_letra.destroy if @concluido_inciso_letra
  end

  def self.down
    add_column(:motivo_conclusions, :integer)
    add_column(:motivos_conclusions, :articulo)
    add_column(:motivos_conclusions, :fraccion)
    add_column(:motivos_conclusions, :descripcion)
    remove_columns :motivo_conclusions, :fundamento
    remove_columns :motivo_conclusions, :causa
    remove_columns :motivo_conclusions, :resumen
    remove_columns :motivo_conclusions, :created_at
    remove_columns :motivo_conclusions, :updated_at
    remove_index :motivo_conclusions,  "motivo_conclusiones_fundamento"
   end
end
