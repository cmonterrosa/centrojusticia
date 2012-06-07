class ParticipantesController < ApplicationController
  def new_or_edit
    render :text => params[:id]
  end
end
