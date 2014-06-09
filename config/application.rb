require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Remisctrl
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Buenos Aires'

    # Rails I18n validation deprecation warning - ver http://stackoverflow.com/q/20361428
    # config.i18n.enforce_available_locales = true
    # Actualmente sólo funciona con false - ver https://github.com/svenfuchs/i18n/issues/224
    I18n.config.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
	config.i18n.default_locale = "es-AR"

    # añado el path de los reportes pdf
    config.autoload_paths += %W(#{config.root}/app/pdfs)

    # 20140517 - will_paginate - tamaño de página por defecto
    WillPaginate.per_page = 20
  end
end
