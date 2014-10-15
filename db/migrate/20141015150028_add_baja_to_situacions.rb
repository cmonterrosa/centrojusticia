class AddBajaToSituacions < ActiveRecord::Migration
    def self.up
    Situacion.create(:descripcion => "BAJA") unless Role.find_by_descripcion("BAJA")

    ## Actualizamos a los usuarios bloqueados el estatus de baja#
    @usuarios = User.find(:all)
    @baja = Situacion.find_by_descripcion("BAJA")
    @usuarios.each do |u|
      unless u.activo
         u.update_attributes!(:situacion_id => @baja.id)
         puts("=> #{u.nombre_completo} Causa BAJA")
      end
    end
    end

  def self.down
     Role.find_by_descripcion("BAJA").destroy if  Role.find_by_descripcion("BAJA")
  end
end
