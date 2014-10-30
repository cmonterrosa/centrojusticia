class Role < ActiveRecord::Base
   has_and_belongs_to_many :users
   has_and_belongs_to_many :estatus

  

  def usuarios_disponibles(date=nil)
        fecha = (date) ? date.strftime('%Y-%m-%d %H:%M:%S') : Time.now.strftime('%Y-%m-%d %H:%M:%S')
        return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id 
                                 INNER JOIN roles r on ru.role_id=r.id
                                 WHERE users.activo= true AND users.id not in (select user_id as id from movimientos where ('#{fecha}' BETWEEN fecha_inicio AND fecha_fin))
                                 AND r.name='#{self.name}'")

  end

  ##### TODOS LOS USUARIOS CON CIERTO ROLE ######
  def todos_usuarios
    return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id 
                             INNER JOIN roles r on ru.role_id=r.id
                             WHERE users.activo=true AND r.name='#{self.name}'")
  end

  def usuarios_disponibles_vespertinos(date=Time.now)
    ############## SOLO MUESTRA A LOS QUE TIENEN GUARDIA ##################
    return User.find_by_sql("SELECT users.* from users
                                 inner join roles_users ru on users.id=ru.user_id
                                 INNER JOIN roles r on ru.role_id=r.id
                                 INNER JOIN movimientos mov on users.id=mov.user_id
                                 INNER JOIN situacions sit on mov.situacion_id=sit.id
                                 WHERE r.name = '#{self.name}' AND
                                 sit.descripcion in ('GUARDIA') AND
                                 ('#{date.strftime('%Y-%m-%d')} 08:01' BETWEEN fecha_inicio AND fecha_fin)")
  end


  def usuarios_disponibles_sesiones(fecha_hora_sesion=nil)
        fecha_hora_sesion = (fecha_hora_sesion) ? fecha_hora_sesion : Time.now
        return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id
                                 INNER JOIN roles r on ru.role_id=r.id
                                 WHERE users.activo=1 AND users.id not in (select user_id as id from movimientos where (\'#{fecha_hora_sesion.strftime('%Y-%m-%d %H:%M:%S')}\' BETWEEN fecha_inicio AND fecha_fin))
                                 AND users.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = \'#{fecha_hora_sesion.strftime('%Y-%m-%d')}\' AND hora= #{fecha_hora_sesion.strftime('%H')} AND minutos= #{fecha_hora_sesion.strftime('%M')} AND mediador_id is NOT NULL)
                                 AND  users.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = \'#{fecha_hora_sesion.strftime('%Y-%m-%d')}\' AND hora= #{fecha_hora_sesion.strftime('%H')} AND minutos= #{fecha_hora_sesion.strftime('%M')} AND comediador_id IS NOT NULL)
                                 AND r.name='#{self.name}'
                                 ORDER BY users.nombre, users.paterno, users.materno")
  end

    def usuarios_disponibles_sesiones_funcion(fecha_hora_sesion=nil,funcion=nil)
        fecha_hora_sesion = (fecha_hora_sesion) ? fecha_hora_sesion : Time.now
        if funcion
          return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id
                                 INNER JOIN roles r on ru.role_id=r.id
                                 WHERE users.activo=1 AND users.id not in (select user_id as id from movimientos where situacion_id != 3 AND (\'#{fecha_hora_sesion.strftime('%Y-%m-%d %H:%M:%S')}\' BETWEEN fecha_inicio AND fecha_fin))
                                 AND users.id not in (select #{funcion}_id from sesions WHERE cancel is NULL AND activa = 1 AND fecha = \'#{fecha_hora_sesion.strftime('%Y-%m-%d')}\' AND hora= #{fecha_hora_sesion.strftime('%H')} AND minutos= #{fecha_hora_sesion.strftime('%M')} AND #{funcion}_id is NOT NULL)
                                 AND r.name='#{self.name}'
                                 ORDER BY users.nombre, users.paterno, users.materno")
        else
           return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id
                                 INNER JOIN roles r on ru.role_id=r.id
                                 WHERE users.activo=1 AND users.id not in (select user_id as id from movimientos where situacion_id != 3 AND (\'#{fecha_hora_sesion.strftime('%Y-%m-%d %H:%M:%S')}\' BETWEEN fecha_inicio AND fecha_fin))
                                 AND users.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = \'#{fecha_hora_sesion.strftime('%Y-%m-%d')}\' AND hora= #{fecha_hora_sesion.strftime('%H')} AND minutos= #{fecha_hora_sesion.strftime('%M')} AND mediador_id is NOT NULL)
                                 AND  users.id not in (select comediador_id from sesions WHERE cancel is NULL AND activa = 1 AND fecha = \'#{fecha_hora_sesion.strftime('%Y-%m-%d')}\' AND hora= #{fecha_hora_sesion.strftime('%H')} AND minutos= #{fecha_hora_sesion.strftime('%M')} AND comediador_id IS NOT NULL)
                                 AND r.name='#{self.name}'
                                 ORDER BY users.nombre, users.paterno, users.materno")
        end

  
  end


end