require 'omniauth-oauth2'
require 'rest_client'

module OmniAuth
  module Strategies
    class Gsrn < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "Gsrn"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.

      option :client_options, {
          site: "https://socialauth.intelen.com",
          authorize_url: "/authorize_x.php",
          token_url: "https://socialauth.intelen.com/token_x.php",
          redirect_uri: 'https://rat.socialenergy-project.eu/users/auth/gsrn/callback/'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['sub'] }

      info do
        {
            :name => raw_info['name'],
            :email => raw_info['email']
        }
      end

      extra do
        {
            'raw_info' => raw_info
        }
      end

      def raw_info
        Rails.logger.debug "the access token is #{access_token.inspect}"
        Rails.logger.debug "the credentials are #{credentials.inspect}"
        @raw_info ||= access_token.get('/userinfo_x.php').parsed
      end

      def self.validate_gsrn_token(email, token)
        return if token.nil? or email.nil? or token.length < 5 or email.length < 5
        response = RestClient.post('https://socialauth.intelen.com/resource.php', "access_token=#{token}")
        result = JSON.parse response.body
        Rails.logger.debug "The results is #{result}"

        if result["success"] and result["email"] == email
          user = User.find_by(email: email, provider: 'Gsrn', uid: result['user_id'])
          if user == nil
            pass = SecureRandom.hex
            user = User.new(email: email, provider: 'Gsrn', uid: result['user_id'], name: result['username'], password: pass, password_confirmation: pass)
            user.save!
          end
          return user
        end
      end
    end
  end
end


Warden::Manager.before_logout do |user,auth,opts|
  if user.provider == 'Gsrn'
    request = {username: user.uid}
    response = RestClient.post('https://socialauth.intelen.com/removesession.php', request)
    Rails.logger.debug("Request: '#{request}', Response: #{response}")
  end
  Rails.logger.debug("Sign out clicked")

#  user.forget_me!
#  auth.response.delete_cookie "remember_token"
end
