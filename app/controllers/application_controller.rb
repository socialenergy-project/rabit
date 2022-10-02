require 'rack-mini-profiler'

class ApplicationController < ActionController::Base

  before_action :validate_gsrn_token
  # acts_as_token_authentication_handler_for User

  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  include CanCan::ControllerAdditions

  before_action :authenticate_user! # , :except => [:getdata, :prosumer, :getdayahead]
  before_action :check_messages

  before_action do
    if current_user && current_user.has_role?(:admin)
      Rack::MiniProfiler.authorize_request
    end
  end


  def check_messages
    current_user&.received_messages&.sent&.update_all(status: :notified)
  end

  check_authorization :unless => :do_not_check_authorization?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to request.referer || root_path, :alert => exception.message }
      format.json { render json: {"error": exception.message}, status: :unauthorized }
    end
  end

  helper_method :sort_column, :sort_direction

  def after_sign_in_path_for(resource)
    logger.debug "Just signed in from #{resource}, #{request.referer}"

    if [ 'https://socialauth.intelen.com',
         'https://rat.socialenergy-project.eu/users/auth/gsrn',
         'https://rabit.socialenergy-project.eu/users/auth/gsrn',
         'https://socialauth.intelen.com/login/index.php' ].include? request.referer
      return super
    end

    sign_in_path = Rails.application.routes.recognize_path(new_user_session_path) rescue nil
    referer_path = Rails.application.routes.recognize_path(request.referer) rescue nil
    logger.debug "1: #{request.referer.inspect} referer: #{referer_path.inspect}, sign_in_url: #{sign_in_path}"
    if referer_path == sign_in_path
      logger.debug "paths are equal"
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def validate_gsrn_token
    email = request.headers["X-User-Email"]
    token = request.headers["X-User-Token"]
    logger.debug "X-User-Email: #{email}"
    logger.debug "X-User-Token: #{token}"
    user = OmniAuth::Strategies::Gsrn.validate_gsrn_token email, token
    sign_in(user, scope: :user, store: false) unless user.nil?
  rescue RestClient::ExceptionWithResponse => e
    logger.error "#{e.class}, #{e.message}"
    logger.error e.backtrace.join("\n")
    render json: e.response, status: e.http_code
  rescue StandardError => e
    logger.error "#{e.class}, #{e.message}"
    logger.error e.backtrace.join("\n")
    render json: {error: e.message}, status: :internal_server_error
  end

  def do_not_check_authorization?
    respond_to?(:devise_controller?) # or
    # condition_one? or
    # condition_two?
  end

  def sort_column
    field_exists?(params[:sort]) ? params[:sort] : field_exists?("name") ? "name" : "id"
  end

  def field_exists?(column)
    controller_name.classify.constantize.column_names.include? column
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
