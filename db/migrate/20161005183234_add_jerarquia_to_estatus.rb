class AddJerarquiaToEstatus < ActiveRecord::Migration
  def self.up
    add_column :estatus, :jerarquia, :integer
    Estatu.reset_column_information
    Estatu.find(:all).each do |e|
      e.jerarquia ||= e.id
      e.save
    end

   puts("=> Reorganizando estatus")
   @comparecencia_concluida = Estatu.find_by_clave("comp-conc")
   @tramite_concluido = Estatu.find_by_clave("tram-conc")
   Estatu.find_by_clave("tram-inic").tramites(:conditions => ["YEAR(fechahora) = ?", Time.now.year]).each do |t|
      t.update_attributes!(:estatu_id => @comparecencia_concluida.id)  if Comparecencia.count(:tramite_id, :conditions =>["tramite_id =?", t.id]) > 0
      #puts t.update_attributes!(:estatu_id => @tramite_concluido.id)  if Concluido.exists?(:tramite_id => t.id)
   end
  
  end

  def self.down
    remove_column :estatus, :jerarquia
  end
end
