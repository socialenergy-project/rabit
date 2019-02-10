require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/test_unit'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    host! "localhost:3000"

    WebMock.stub_request(:post, "https://socialenergy.intelen.com/index.php/webservices/activitylcmsgame")
           .with(
              body: {"username"=>nil},
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip, deflate',
                'Content-Length'=>'8',
                'Content-Type'=>'application/x-www-form-urlencoded',
                'Host'=>'socialenergy.intelen.com',
                'Timeout'=>'10',
                'User-Agent'=>'rest-client/2.0.2 (linux-gnu x86_64) ruby/2.5.1p57'
              }
            ).to_return(status: 200, body: "", headers: {})

  end

  def sign_in_as_admin
    user = users(:one)
    user.add_role "admin"
    sign_in user
    user
  end

  def sign_in_as_user(user_id = :two)
    user = users(user_id)
    sign_in user
    user
  end

end
