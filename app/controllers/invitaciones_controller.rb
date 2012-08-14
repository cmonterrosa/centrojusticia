include SendDocHelper
class InvitacionesController < ApplicationController
  def index
  end

  def generar
   send_doc_jdbc("invitacion", "invitacion", params, output_type = 'pdf')
  end

end
