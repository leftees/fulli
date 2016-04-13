class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: :home
  before_action :configure_permitted_parameters, if: :devise_controller?

  def home
  end

  protected

  def page
    (params[:page] || 1).to_i
  end

  def after_sign_in_path_for(resource)
    if request.referer == new_user_session_url || new_user_registration_url
      organisations_path
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :name, :avatar)
    end
  end

  def organisation
    @organisation ||= if (id = params[:organisation_id] || params[:id])
                        Organisation.friendly.find(id).decorate context: self
                      else
                        Organisation.new.decorate context: self
                      end
  end
  helper_method :organisation
end
