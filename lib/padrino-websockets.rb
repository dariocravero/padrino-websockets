module Padrino
  module WebSockets
    module Helpers
      require 'securerandom'

      def set_websocket_user
        session['websocket_user'] ||= SecureRandom.uuid
      end
    end
    class << self
      ##
      # Main class that register this extension.
      #
      def registered(app)
        require 'padrino-websockets/base-event-manager'

        if defined?(::SpiderGazelle)
          require 'padrino-websockets/spider-gazelle'
          app.helpers Padrino::WebSockets::SpiderGazelle::Helpers
          app.extend Padrino::WebSockets::SpiderGazelle::Routing
        elsif defined?(::Faye::WebSocket)
          require 'padrino-websockets/faye'
          ::Faye::WebSocket.load_adapter('thin') if defined?(::Thin)
          require 'padrino-websockets/faye/puma-patch' if defined?(Puma)
          app.helpers Padrino::WebSockets::Faye::Helpers
          app.extend Padrino::WebSockets::Faye::Routing
        else
          logger.error %Q{Can't find a WebSockets backend. At the moment we only support
            SpiderGazelle and Faye Websockets friendly application backends (Puma and Thin work,
            Rainbows, Goliath and Phusion Passenger remain untested and may break).}
          raise NotImplementedError
        end

        app.helpers Padrino::WebSockets::Helpers
      end
      alias :included :registered
    end
  end
end
