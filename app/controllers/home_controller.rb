class HomeController < ApplicationController

	#skip_filter :index , :only
  before_action :authenticate_user!, except: :index

  def index
		redirect_to :action => 'show' if user_signed_in?
  end

  def show
		p current_user
  end
end
