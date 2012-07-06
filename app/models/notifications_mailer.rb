class NotificationsMailer < ActionMailer::Base

  #---- tramites ---
  def tramite_created(tramite, user)
    setup_email(user)
    @tramite = Tramite.find(tramite)
    @subject    += "Tramite: #{tramite.id} ha sido creado"
    @body[:url]  = "http://#{SITE_URL}/tramites/show/#{@tramite.id}"
  end
    def tramite_updated(tramite, user)
     setup_email(user)
    @subject    +=  "tramite: #{tramite.id} ha sido modificado"
    @body[:url]  = "http://#{SITE_URL}/tramites/show/#{tramite.id}"
  end

   #--- orientaciones ---
   def orientacion_created(orientacion, user)
      setup_email(user)
      @subject    += "Orientación ha sido creada"
      @body[:url]  = "http://#{SITE_URL}/orientacions/show/#{orientacion.id}"
   end


   def orientacion_updated(orientacion, user)
      setup_email(user)
      @subject    +=  "--  #{orientacion.tramite.id} ha sido modificado"
      @body[:url]  = "http://#{SITE_URL}/orientacions/show/#{orientacion.id}"
   end

  protected
 
  def setup_email(user)
      @recipients = "#{user.email}"
      @from = "Centro Estatal de Justicia Alternativa Chiapas <elreyazucar@gmail.com>"
      @sent_on  = Time.now
      @body[:user] = user
      @subject   = " "
      @content_type = "text/html"
  end

end
