class Invitacion < ActiveRecord::Base
  belongs_to :sesion

  def signed?
    (self.sesion.signed_at)? (return true) : (return false)
  end

  def especialista
    return User.find(Sesion.find(self.sesion_id).mediador_id)
  end

  def subdireccion
    return Subdireccion.find(User.find(self.user_id).subdireccion_id)
  end

 
  def orientacion
    return Orientacion.find_by_tramite_id(Tramite.find(Sesion.find(self.sesion_id).tramite_id))
  end

   def articulo
    o = orientacion
    articulo = (o.sexo == 'M') ? "del" : "de la"
    return articulo
   end

   def articulo_esp
    articulo = (Sesion.find(self.sesion_id).mediador.sexo == "M") ? "el" : "la"
    return articulo
   end

   def fecha_sesion
     #"05 de marzo, a las 3 de la tarde"
     @sesion = Sesion.find(self.sesion_id)
     return "#{@sesion.fecha.strftime('%d de %B')}, #{Horario.find(@sesion.horario_id).hora_completa_turno}"
   end

#    param["P_NOMBRE"]={:tipo=>"String", :valor=>"Carlos Augusto Monterrosa López"}
#    param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>"Lic. Amauri Palacios Aquino"}
#    param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>"Rodrigo Domínguez Moscoso"}
#    param["P_ARTICULO"]={:tipo=>"String", :valor=>"la"}
#    param["P_LUGAR"]={:tipo=>"String", :valor=>"Tuxtla Gutiérrez, Chiapas;"}
#    param["P_FECHA"]={:tipo=>"String", :valor=>"21 de Diciembre de 2012"}
#    param["P_SOLICITANTE"]={:tipo=>"String", :valor=>"C. Norma Espinoza Vázquez"}
#    param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"17 de febrero de 2012"}
#    param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"05 de marzo, a las 3 de la tarde"}
end
