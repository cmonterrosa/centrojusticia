class Role < ActiveRecord::Base
   has_and_belongs_to_many :users
   has_and_belongs_to_many :estatus

  

  def usuarios_disponibles
        return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id 
                                 INNER JOIN roles r on ru.role_id=r.id
                                 WHERE users.id not in (select user_id as id from movimientos where ('#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}' BETWEEN fecha_inicio AND fecha_fin))
                                 AND r.name='#{self.name}'")

  end

#  def users
#      return User.find(:all, :select => "u.*", :joins => "u, roles_users ru", :conditions => ["u.id=ru.user_id AND ru.role_id=?", self.id], :order => "u.login, u.paterno, u.materno")
#  end
end