class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_admin_user

  def set_admin_user
    User.current = User.admin
    session[:user] = User.current.id
  end

  def current_user
  	User.current
  end

  # standard layout to all controllers
  helper 'layout'

  def home
    render :text => "This is the dummy app for Katello engine.  Please go to /katello"
  end

end
