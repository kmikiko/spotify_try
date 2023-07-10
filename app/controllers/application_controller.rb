class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_profile_attributes => [:name, :icon, :image_cache,  :introduction]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_profile_attributes => [:name, :icon, :image_cache, :introduction]])
  end
end
