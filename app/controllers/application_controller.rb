# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  # Security functions
  include Security

  layout 'oficial', :except => :autenticacion

  Date::MONTHNAMES = [nil, "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
 
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

#  # General method to render a 404
#  def render_missing_page
#    render :template => "layouts/404", :layout => "oficial", :status => 404
#  end


end
