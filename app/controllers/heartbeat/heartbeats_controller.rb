module Heartbeat
  class HeartbeatsController < ApplicationController

    if Rails.env.in? %w(development staging production)
      http_basic_authenticate_with \
        name: Heartbeat.configuration.basic_auth_credentials[:username], \
        password: Heartbeat.configuration.basic_auth_credentials[:password]
    end

    respond_to :json

    def index
      heartbeat = Heartbeat::Monitor.new.check

      # We're abusing the status code when the heartbeat is not OK,
      # technically we're still providing a service by returning
      # the json in the response body, but it's more for ease of
      # monitoring with Pingdom and such.
      status = heartbeat.ok? ? :ok : :service_unavailable
      render json: heartbeat, status: status
    end
  end
end


