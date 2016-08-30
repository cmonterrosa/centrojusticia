class ChangeEstatusDescription < ActiveRecord::Migration
  def self.up
    convenio = Estatu.find_by_clave("proc-conv")
    convenio.update_attributes!(:descripcion => "Convenio capturado") if convenio
    adj_car = Estatu.create(:clave => "adj-car", :descripcion => "Archivo cargado") unless Estatu.exists?(:clave => "adj-car")
    adj_eli = Estatu.create(:clave => "adj-eli", :descripcion => "Archivo eliminado") unless Estatu.exists?(:clave => "adj-eli")

    ### Actualizamos flujo ###
    compcon = Estatu.find(:first, :conditions => ["clave = ?", 'comp-conc'])
    compcon.roles.each do |r|
       unless r.estatus.include?(adj_car) && ! adj_car.roles.empty?
         adj_car.roles << Role.find_by_name(r.name)
         puts("=> ADJ_CAR GUARDADO") if adj_car.save
       end
       unless r.estatus.include?(adj_eli) && ! adj_car.roles.empty?
         adj_eli.roles << Role.find_by_name(r.name)
         puts("=> ADJ_ELI GUARDADO") if adj_eli.save
       end
    end
  end

  def self.down
    puts("=> NO EXISTE ACCION REVERSIVA")
  end
end
