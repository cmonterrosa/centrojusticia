class AdminController < ApplicationController
  #before_filter :login_required
  require_role [:admin], :except => [:index]
  
  def index

  end

  #--- administracion de roles y estatus por visualizar
  def roles_estatus
    @role = Role.find(1)
  end

  def filtro_role
    if params[:role_id].size > 0
      @role = Role.find(params[:role_id])
      return render(:partial => 'estatus_by_role', :layout => false) if request.xhr?
    else
      render :text => "No se pudo realizar la búsqueda, verifique"
    end
  end

  def update_role_estatus
    @role = Role.find(params[:id])
    @role.estatus = []
    @role.estatus =  Estatu.find(params[:estatu][:role_ids]) if params[:estatu][:role_ids]
    if @role.save
      flash[:notice] = "Estatus actualizado correctamente"
      redirect_to :action => "roles_estatus"
    end
  end

  #--- administración de flujo de peticiones
  def flujo
    @flujos = Flujo.all
    @estatus = Estatu.all
    @users = Role.all
  end

  def add_flujo
    if params[:flujo][:role_id] && params[:flujo][:old_status_id] && params[:flujo][:new_status_id]
       @flujo = Flujo.new(params[:flujo])
       if @flujo.save
         flash[:notice] = "Guardado correctamente"
       else
         flash[:notice] = "No se puedo guardar, verifique"
       end
       redirect_to :action => "flujo"
    else
      flash[:notice] = "No se puedo guardar, verifique"
      render :action => "flujo"
    end
  end

  def delete_flujo
    if params[:id]
      @flujo = Flujo.find(params[:id])
      if @flujo.destroy
        flash[:notice] = "Registro eliminado correctamente"
      else
         flash[:notice] = "No se pudo eliminar, verifique"
      end
      redirect_to :action => "flujo"
    end
  end


  #------ Administración de materias -----
  def show_materias
    @materias = Materia.find(:all, :order => "descripcion")
  end

  def members_by_materia
    @materia = Materia.find(params[:id])
    @especialistas = []
      Role.find(:first, :conditions => ["name = ?", 'especialistas']).users.each{|user|
        unless @materia.users.include?(user)
          @especialistas << user
        end
      }
  end

  def add_user_materia
    @materia = Materia.find(params[:materia])
    @materia.users << User.find(params[:user][:user_id])
    if @materia.save
      flash[:notice] = "Usuario agregado correctamente"
    else
      flash[:notice] = "El usuario no fue agregado, verifique"
    end
    redirect_to :action => "members_by_materia", :id => @materia
  end

    def delete_user_materia
      @materia = Materia.find(params[:materia])
      @user = User.find(params[:id])
      @materia.users.delete(@user)
      if @materia.save!
        flash[:notice] = "Especialista eliminado del perfil correctamente"
      else
        flash[:notice] = "No se pudo eliminar, verifique"
      end
      redirect_to :action => "members_by_materia", :id => @materia
    end



  #------- Administracion de Usuarios ---------
  def members_by_role
     @role = Role.find(params[:id])
     @users = []
      User.find(:all).each{|user|
        unless @role.users.include?(user)
          @users << user
        end
      }
  end

  def add_user
  @role = Role.find(params[:role])
  @role.users << User.find(params[:user][:user_id])
  if @role.save
    flash[:notice] = "Usuario agregado correctamente"
  else
    flash[:notice] = "El usuario no fue agregado, verifique"
  end
  redirect_to :action => "members_by_role", :id => @role

  end

  def new_user
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
    unless @role.users.include?(user)
      @users << user
    end
    }
  end

  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
     @role.users.delete(@user)
     if @role.save!
       flash[:notice] = "Elemento eliminado del perfil correctamente"
     else
       flash[:notice] = "No se pudo eliminar, verifique"
     end
      redirect_to :action => "members_by_role", :id => @role
  end

  def show_roles
    @roles = Role.find(:all)
    @token = generate_token
  end

  def show_users
    @usuarios = User.find(:all, :order => "login, paterno, materno, nombre")
    @token = generate_token
  end

# -- termina modulo de administracion de usuarios ----

#--- listado de usuarios por area ---

 def show_users_by_area
    @areas = Subdireccion.find(:all, :order => "municipio_id")
 end

 def  update_list_usuarios
     @users = User.find(:all, :conditions => ["subdireccion_id = ?", params[:id]], :order => "paterno, materno, nombre")
      @token = generate_token
     render :layout => false
 end

 def change_user_estatus
   if validate_token(params[:t]) && @user = User.find(params[:id])
     @mensaje = @user.activo ? "Usuario bloqueado" : "Usuario reactivado"
     (@user.activo) ? @user.update_attributes!(:activo => false) : @user.update_attributes!(:activo => true)
     flash[:notice] = @mensaje
   else
     flash[:notice] = "No se pudo bloquear usuario, verifique"
   end
   redirect_to :action => "show_users_by_area"
 end

 def change_user_area
   @user = User.find(params[:id])
 end

end
