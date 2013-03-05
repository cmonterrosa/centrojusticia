 # Security functions
  include Security
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def day_of_the_week(day)
      @dias = {1 => "Lunes", 2 => "Martes", 3 => "Miércoles", 4 => "Jueves",  5 => "Viernes", 6 => "Sábado"}
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
