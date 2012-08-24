class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end

  def new_from_admin
    @token = params[:id]
    if validate_token(@token)
       @user = User.new
    else
      redirect_to :controller=> "admin"
    end
   
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.activo=true
    if params[:codigo][:numero].strip != CODIGO_SEGURIDAD
      flash[:error] = "Es necesario el codigo de seguridad,  contacte al administrador"
      render :action => 'new'
    end
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Gracias por registrarte."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  # create user from admin role not need activation
  def save
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Usuario creado correctamente"
      redirect_to :action => "show_roles", :controller => "admin"
    else
      flash[:notice]  = "No se puedo crear usuario, verifique los datos"
      render :action => 'new_from_admin'
    end
  end

end
