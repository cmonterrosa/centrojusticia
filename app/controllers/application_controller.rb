#!/bin/env ruby
# encoding: utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'will_paginate'
require 'will_paginate/array'
require 'net/http'
require 'uri'


class Time
   alias :strftime_nolocale :strftime

  def strftime(format)

    format = format.dup

    format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])

    format.gsub!(/%A/, Date::DAYNAMES[self.wday])

    format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])

    format.gsub!(/%B/, Date::MONTHNAMES[self.mon])

    self.strftime_nolocale(format)

  end
end


class Date

MONTHNAMES = [nil] + %w(Enero Febrero Marzo Abril Mayo Junio Julio
Agosto Septiembre Octubre Noviembre Diciembre)

DAYNAMES = %w(Domingo, Lunes, Martes, Miercoles, Jueves, Viernes,
Sabado)

module Format

    MONTHS = {

      'Enero'  => 1, 'Febrero' => 2, 'Marzo'    => 3, 'Abril'    => 4,

      'Mayo'      => 5, 'Junio'     => 6, 'Julio'     => 7, 'Agosto' => 8,

     'Septiembre'=> 9, 'Octubre'  =>10, 'Noviembre' =>11, 'Diciembre'=>12
    }

  DAYS = {

      'Domingo'   => 0, 'Lunes'   => 1, 'Martes'  => 2, 'Miercoles'=> 3,

      'Jueves' => 4, 'Viernes'   => 5, 'Sabado' => 6

    }

end
end


class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  ### Si existen mensajes ###
  #before_filter :check_if_mensaje_exists?

  # Security functions
  include Security

  
  layout 'kolaval'#, :except => :autenticacion

# Scrub sensitive parameters from your log
# filter_parameter_logging :password

#  # General method to render a 404
#  def render_missing_page
#    render :template => "layouts/404", :layout => "oficial", :status => 404
#  end

 def update_tramite_model(tramite=nil)
    @tramite=tramite if tramite
    flash[:notice] = (@tramite.update_flujo_estatus!(current_user)) ? "Registro actualizado correctamente" :  "No se pudo guardar, verifique"
    #redirect_to :action => "list"
 end

 def to_iso(texto)
    c = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    iso = c.iconv(texto)
    return iso
 end

 def write_log(text=nil, user=nil)
   user = (user) ? user.nombre_completo : "DESCONOCIDO"
   text = (text) ? text.upcase : ""
   Rails.logger.info "=> (#{Time.now.strftime('%d/%m/%Y  %H:%M:%S')}" +  "/  USUARIO: #{user}) - " + text
   #Rails.logger.debug "=> (#{Time.now.strftime('%d/%m/%Y  %H:%M:%S')}" +  "/  USUARIO: #{user}) - " + text
 end

 def clean_string(string)
   (string) ? (return string.to_s.gsub(/\$/, '\$').gsub(/\"/, '\"')) : (return "")
 end

 def fecha_string(date=Time.now)
    meses = %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
    dia,mes,anio = date.strftime("%d"), date.strftime("%m"), date.strftime("%Y")
    mes = meses[(mes.to_i - 1)]
    return "#{dia} de #{mes} de #{anio}".upcase
 end

  def inhabil?(date=Time.now)
    date = DateTime.parse(date.strftime('%Y-%m-%d') + " 08:00")
    inhabil = ((1..5)===date.wday) ? false : true
    if inhabil
       return true
    else
       if Festivo.find(:first, :conditions => ["? between fecha_inicio and fecha_fin", date.strftime('%Y-%m-%d %H:%M')])
         return true
       else
         return false
       end
    end
  end



  def check_if_mensaje_exists?
       if MENSAJE
        if current_user && MENSAJE.has_key?(current_user.login.to_sym)
            require 'date'
            flash[:warning] = MENSAJE[current_user.login.to_sym][:texto] if DateTime.now < Date.parse(MENSAJE[current_user.login.to_sym][:expiracion])
        end
      end
    end

  def url_is_active?(host='localhost', port=3000)
    targetIp = host
    targetPort = port
    begin
        if server = TCPSocket.open(targetIp, targetPort)
          puts "Connected to Server => " + targetIp + ":" + targetPort
          server.close
          return true
        end
    rescue => ex
        puts "Connection to Server Failed:
        #{ex.class}: #{ex.message}"
        return false
      end
    end

end


 



