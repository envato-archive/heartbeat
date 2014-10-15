module Heartbeat
  module Pulses
    class RailsApp < Base
      def tick
        check "the version of ruby installed" do
          data :ruby_version, ruby_version
        end

        check "the version of rails installed" do
          data :rails_version, rails_version
        end
      end

      private

      def ruby_version
        RUBY_VERSION
      end

      def rails_version
        Rails::VERSION::STRING
      end
    end
  end
end
