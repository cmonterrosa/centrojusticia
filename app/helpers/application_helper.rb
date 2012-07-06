# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def day_of_the_week(day)
      @dias = {1 => "Lunes", 2 => "Martes", 3 => "Miércoles", 4 => "Jueves",  5 => "Viernes", 6 => "Sábado"}
      return @dias[day]
  end

end
