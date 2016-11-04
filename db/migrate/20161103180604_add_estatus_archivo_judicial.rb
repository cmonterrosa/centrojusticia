class AddEstatusArchivoJudicial < ActiveRecord::Migration
  def self.up
    last_jerarquia = (Estatu.maximum(:jerarquia).to_i)
    Estatu.create(:clave => "arch-judi", :descripcion => "Enviado a archivo judicial", :jerarquia => last_jerarquia) unless Estatu.exists?(:clave => "arch-judi")
    
    #### Creamos registro en flujo ####
    old_status = Estatu.find_by_clave("tram-conc")
    new_status = Estatu.find_by_clave("arch-judi")
    role_convenios = Role.find_by_name("convenios")
    role_subdireccion = Role.find_by_name("subdireccion")
    if (old_status && new_status)
      Flujo.create(:old_status_id => old_status.id, :descripcion => "Mandar a archivo", :new_status_id => new_status.id, :role_id => role_convenios.id, :orden => 10) unless Flujo.exists?(:role_id => role_convenios.id, :new_status_id => new_status.id)
      Flujo.create(:old_status_id => old_status.id, :descripcion => "Mandar a archivo", :new_status_id => new_status.id, :role_id => role_subdireccion.id, :orden => 11) unless Flujo.exists?(:role_id => role_subdireccion.id, :new_status_id => new_status.id)
    end

    ## Establecemos visible el status para multiples roles ##
    roles = Role.find(:all, :conditions => ["name in (?)", ['convenios', 'especialistas', 'subdireccion', 'direccion', 'agenda', 'controlagenda', 'atencionpublico', 'jefeatencionpublico', 'especialistas_externos', 'visitadores', 'oficinasubdireccion']])
    roles.each do |r|
        r.estatus << Estatu.find_by_clave("arch-judi")
        puts "Estatus de archivo judicial agregado a role: #{r.name} " if r.save
    end
end

  def self.down
     Estatu.find_by_clave("arch-judi").destroy unless Estatu.exists?(:clave => "arch-judi")
  end
end
