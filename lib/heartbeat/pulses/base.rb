module Heartbeat
  module Pulses
    class Base
      RETRY_DEFAULTS = {
        tries: 3,
        sleep: 0.5, # for exponential backoff, do: lambda { |nth_try| 4**nth_try }, nth_try is zero-based
      }

      class << self
        def pulse_name
          @name ||= name.underscore.split('/').last
        end
      end

      class InvalidState < StandardError; end

      attr_reader :exceptions, :data

      def initialize
        @exceptions = []
        @data = {}
        @ticked = false
      end

      def name
        self.class.pulse_name
      end

      def tick
        raise NotImplementedError.new("You must implement the `tick` method!")
      end

      def as_json
        raise InvalidState, "as_json called before tick" unless ticked?
        @as_json ||= {
          up: up?,
          errors: exceptions,
          data: @data,
        }
      end

      def up?
        raise InvalidState, "up? called before tick" unless ticked?
        exceptions.empty?
      end

      private

      def data(key, value)
        @data[key] = value
      end

      def check(subject, options = {}, &block)
        @ticked = true
        retryable(RETRY_DEFAULTS.merge(options)) do
          yield
        end
      rescue => exception
        @exceptions << {
          subject: subject,
          message: exception.message,
          backtrace: exception.backtrace,
          details: exception,
        }
      end

      def ticked?
        @ticked
      end
    end
  end
end
