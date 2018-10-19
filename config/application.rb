require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Website

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.exceptions_app = self.routes
    config.autoload_paths += %W["#{config.root}/app/validators/"]

    config.time_zone = 'London'

    # Prevent Rails' default behaviour from breaking the form layout
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }

    # Allow for CORS
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }

    # Get rid of deprecation warnings
    config.active_record.time_zone_aware_types = [:datetime, :time]
  end

end
