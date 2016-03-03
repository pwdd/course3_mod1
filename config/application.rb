require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Raceday
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    Mongoid.load!('./config/mongoid.yml')
  end
end