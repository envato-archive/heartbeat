module Heartbeat
  class Engine < ::Rails::Engine
    isolate_namespace Heartbeat
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
