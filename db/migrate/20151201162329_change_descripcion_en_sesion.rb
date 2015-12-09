class ChangeDescripcionEnSesion < ActiveRecord::Migration
  def self.up
    @ensesion = Estatu.find_by_clave("en-sesion")
    @ensesion.update_attributes!(:descripcion => "Resultado de sesión capturado")
    @validacion_convenios = Role.create(:name => "validacion_convenios", :descripcion => "Validación de convenios", :prioridad => 23) unless Role.exists?(:name => "validacion_convenios")
  end

  def self.down
    @ensesion = Estatu.find_by_clave("en-sesion")
    @ensesion.update_attributes!(:descripcion => "En sesión")
    Role.find_by_name("validacion_convenios").destroy if Role.exists?(:name => "validacion_convenios")
  end
end
