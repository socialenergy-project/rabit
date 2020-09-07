require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RABIT
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.middleware.use ActionDispatch::Session::CookieStore, {:key=>"_rat_session", :cookie_only=>true}

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

require 'fetch_data/flexgrid_client'
$flexgrid_client = FetchData::FlexgridClient.new

# Passenger uses preloading by default, so no need to turn it on.
# Passenger automatically establishes connections to ActiveRecord,
# but for other DBs, you will have to:
PhusionPassenger.on_event(:starting_worker_process) do |forked|
  if forked
    $flexgrid_client = FetchData::FlexgridClient.new
  end
end if Object.const_defined?('PhusionPassenger') 
