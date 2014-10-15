module Heartbeat
  class ApplicationController < ActionController::Base
    def basic_auth_credentials
      Heartbeat.configuration.basic_auth_credentials || {}
    end
  end
end
