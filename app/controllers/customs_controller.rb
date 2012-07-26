class CustomsController < ApplicationController
  def index
    @usuario=current_user
    if @usuario.has_role?(:direccion)
        return render(:partial => 'direccion', :layout => "oficial")
    elsif @usuario.has_role?(:subdireccion)
        return render(:partial => 'subdireccion', :layout => "oficial")
    elsif @usuario.has_role?(:especialistas)
        return render(:partial => 'especialistas', :layout => "oficial")
    elsif @usuario.has_role?(:invitadores)
        return render(:partial => 'invitadores', :layout => "oficial")
    end
  end

  def profile
    @usuario = current_user
  end

end
