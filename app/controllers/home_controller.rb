class HomeController < ApplicationController
  before_filter :login_required
  def index
      redirect_to :controller => "customs"
  end

end
