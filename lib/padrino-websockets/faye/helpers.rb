module Padrino
  module WebSockets
    module Faye
      module Helpers
        def send_message(channel, user, message)
          Padrino::WebSockets::Faye::EventManager.send_message channel, user, message
        end

        def broadcast(channel, message, except=[])
          Padrino::WebSockets::Faye::EventManager.broadcast channel, message, except
        end
      end
    end
  end
end
