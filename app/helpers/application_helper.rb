#!/bin/env ruby
# encoding: utf-8
# Security functions
include Security
# Methods added to this helper will be available to all templates in the application.
require 'fileutils'
 require 'date'

module ApplicationHelper

  def day_of_the_week(day)
      @dias = {1 => "LUNES", 2 => "MARTES", 3 => "MIERCOLES", 4 => "JUEVES",  5 => "VIERNES", 6 => "SÁBADO", 7 => "DOMINGO"}
      return @dias[day]
  end

  def invert_class(clase)
    if clase == 1
      return 0
    else
      return 1
    end
  end


  def to_iso(texto)
    c = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    iso = c.iconv(texto)
    return iso
  end

  def colors_to_days
   return @backgrounds_colors = {0 => "#82FA58", 
                                                   1 => "#feaeff", 2 => "#A9A9F5", 3 => "#31B404", 4=> "#F2F5A9", 5 => "#EDD46F", 6 => "#20d6d0"}
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



def days_in_month(year = Time.now.year, month=Time.now.month)
  (Date.new(year, 12, 31) << (12-month)).day
end

  def dias_habiles_anio_mes(year = Time.now.year, month=Time.now.month)
    @habiles = {}
    (1..days_in_month(year, month)).each do |d|
      fecha = DateTime.civil(year, month, d)
      @habiles[fecha.strftime("%A %d de %B")] = fecha unless inhabil?(fecha)
     end
    #return @habiles.sort{|a1,a2| a2[0]<=>a1[0]} unless @habiles.empty?
    return @habiles.sort_by {|_key, value| value} unless @habiles.empty?
  end

end
