class Invitacion < ActiveRecord::Base
  belongs_to :sesion
  belongs_to :participante

  def signed?
    (self.sesion.signed_at)? (return true) : (return false)
  end

  def especialista
    return User.find(Sesion.find(self.sesion_id).mediador_id)
  end

  def comediador
    return User.find(Sesion.find(self.sesion_id).comediador_id)
  end


  def subdireccion
    return Subdireccion.find(User.find(self.user_id).subdireccion_id)
  end

 
  def orientacion
    return Orientacion.find_by_tramite_id(Tramite.find(Sesion.find(self.sesion_id).tramite_id))
  end

   def articulo
    o = orientacion
    articulo = (o.sexo == 'M') ? "el" : "la"
    return articulo
   end

   def articulo_esp
    return (Sesion.find(self.sesion_id).mediador.sexo == "M") ? "el" : "la"
   end

   def fecha_sesion
     #"05 de marzo, a las 3 de la tarde"
     @sesion = Sesion.find(self.sesion_id)
     return "#{@sesion.fecha.strftime('%d de %B')}, #{Horario.find(@sesion.horario_id).hora_completa_turno}"
   end

   def invitador
     return User.find(self.invitador_id) if self.invitador_id
     return nil
   end



end
