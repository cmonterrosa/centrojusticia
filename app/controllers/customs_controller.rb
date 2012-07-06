class CustomsController < ApplicationController
  def index
    @usuario=current_user
  end

end
