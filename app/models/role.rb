class Role < ActiveRecord::Base
   #has_and_belongs_to_many :users
   has_and_belongs_to_many :estatus
  def users
      return User.find(:all, :select => "u.*", :joins => "u, roles_users ru", :conditions => ["u.id=ru.user_id AND ru.role_id=?", self.id], :order => "u.login, u.paterno, u.materno")
  end
end