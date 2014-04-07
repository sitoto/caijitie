require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"

# upto rails 4
# require "active_resource/railtie"
 require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Caijitie
  class Application < Rails::Application
    config.filter_parameters << :password

    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false
    config.time_zone = "Beijing"

    #config.autoload_paths += %W(#{Rails.root}/app/sweeper)
    config.encoding = "utf-8"

    #config.filter_parameters += [:password]

    config.assets.enabled = true

    config.assets.version = '1.0.1'

    config.generators.stylesheet_engine = :sass
#    config.generators.javascript_engine = :coffee


  end
end
