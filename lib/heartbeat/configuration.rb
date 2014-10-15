require 'heartbeat/pulses/rails_app'

module Heartbeat
  class Configuration
    attr_accessor :pulses, :error_callback, :basic_auth_credentials

    def initialize
      @pulses = [:database]
    end
  end
end
