require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    host! "localhost:3000"
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
