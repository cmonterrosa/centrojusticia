class CierreanioController < ApplicationController
	require_role [:librocontrol, :visitadores, :direccion, :subdireccion]

	def index
		@inicio = @fin = Time.now
	end

	def generar_razonamiento
		#@inicio = Date.parse(params[:fecha_inicio])
		
	@razon ||= Cierreanio.new
    @razon.update_attributes(params[:cierreanio])
    @razon.user_id = current_user.id
    @razon.cargo = current_user.categoria
    @razon.fecha =  @razon.fecha 
    @razon.director = Subdireccion.find(:first, :conditions =>["cargo='DIRECTOR GENERAL'"]).titular                  
    @razon.presidente = MAGISTRADO_PRESIDENTE
    @razon.lugar = LUGAR
    @razon.subdireccion_id = current_user.subdireccion_id    
    @razon.tipo_razon = @razon.tipo_razon

		if @razon.save
	      flash[:notice] = "Registro guardado correctamente"
	        redirect_to :controller => "libro", :action => "index"    
	    else
	      flash[:error] = "no se pudo guardar el registro, verifique"
	      render :action => "index"
	    end
		
	end
end
