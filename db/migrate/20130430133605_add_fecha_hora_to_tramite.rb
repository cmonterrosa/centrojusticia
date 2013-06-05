class AddFechaHoraToTramite < ActiveRecord::Migration
  def self.up
     add_column :tramites, :fechahora, :datetime

     # If tramites have a date in timestamp fields, we copy
     Tramite.find(:all).each do |t|
       if orientacion = Orientacion.find_by_tramite_id(t.id)
          t.update_attributes!(:fechahora => orientacion.created_at) if orientacion.created_at
       else
           t.update_attributes!(:fechahora => t.created_at) if t.created_at
       end
     end

  end

  def self.down
    remove_columns(:tramites, :fechahora)
  end
end
