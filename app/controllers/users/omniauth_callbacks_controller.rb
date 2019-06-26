class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def gsrn
    logger.debug "Signing in from gsrn --> #{request.env["omniauth.auth"]}"
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Gsrn") if is_navigational_format?
    else
      logger.debug "And it dit not persist --> #{@user.errors.messages}"
      session["devise.gsrn_data"] = request.env["omniauth.auth"]
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to new_user_session_url
    end
  end

  def failure
    logger.debug "At failure"
    redirect_to root_path
  end
end
