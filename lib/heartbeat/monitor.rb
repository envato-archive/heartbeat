module Heartbeat
  class Monitor

    class InvalidState < StandardError; end

    def initialize
      @checked = false
    end

    def check
      @checked = true
      pulse_threads.each(&:join)
      self
    end

    def as_json(options={})
      raise InvalidState, "as_json called before check" unless checked?
      Hash[pulses.map { |pulse| [pulse.name, pulse] }]
    end

    def pulses
      @pulses ||= configuration.pulses.map { |pulse| pulse.new }
    end

    def ok?
      raise InvalidState, "ok? called before check" unless checked?
      pulses.all?(&:up?)
    end

    private

    def pulse_threads
      pulses.map do |pulse|
        Thread.new { pulse.tick }
      end
    end

    def checked?
      @checked
    end

    def configuration
      Heartbeat.configuration
    end
  end
end
