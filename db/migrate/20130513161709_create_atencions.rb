class CreateAtencions < ActiveRecord::Migration
  def self.up
    create_table :atencions do |t|
      t.string :descripcion, :limit => 120
    end

   #---- Create catalogue ----
    normal = Atencion.create(:descripcion => "NORMAL")
    extraordinaria = Atencion.create(:descripcion => "EXTRAORDINARIA")
    Atencion.create(:descripcion => "POR ESCRITO")
    Atencion.create(:descripcion => "POR TELEFONO")
    Atencion.create(:descripcion => "POR CORREO ELECTRONICO")

   # --- Bind with tramite model
   add_column :tramites, :atencion_id, :integer
   Tramite.find(:all).each do |t|
      if Extraordinaria.find_by_tramite_id(t.id)
         t.update_attributes!(:atencion_id => extraordinaria.id)
      else
         t.update_attributes!(:atencion_id => normal.id)
      end
     
   end
end

  def self.down
    drop_table :atencions
    remove_columns(:tramites, :atencion_id)
  end
end
