module Padrino
  module WebSockets
    module SpiderGazelle
      module Helpers
        def send_message(channel, user, message)
          Padrino::WebSockets::SpiderGazelle::EventManager.send_message channel, user, message
        end
        def broadcast(channel, message)
          Padrino::WebSockets::SpiderGazelle::EventManager.broadcast channel, message
        end
      end
    end
  end
end
