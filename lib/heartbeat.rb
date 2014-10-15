require 'rails'
require 'retryable'
require 'heartbeat/version'
require 'heartbeat/engine'
require 'heartbeat/pulses/base'
require 'heartbeat/configuration'
require 'heartbeat/monitor'

module Heartbeat
  extend self

  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new

    yield configuration if block_given?
  end
end

Heartbeat.configure


