# Security functions
include Security
# Methods added to this helper will be available to all templates in the application.
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

end
