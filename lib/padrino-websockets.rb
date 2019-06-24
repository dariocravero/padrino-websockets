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
        require 'padrino-websockets/pub_sub'
        # set default pubsub to in-memory.  setting can override with a different
        # implementation in your app settings
        # example:
        # set :websockets_pub_sub, SomeWeirdPubSub.new
        #
        unless app.respond_to?(:websockets_pub_sub)
          app.set :websockets_pub_sub, Padrino::WebSockets::PubSub.new
        end

        if defined?(::SpiderGazelle)
          require 'padrino-websockets/spider-gazelle'
          app.helpers Padrino::WebSockets::SpiderGazelle::Helpers
          app.extend Padrino::WebSockets::SpiderGazelle::Routing
          Padrino::WebSockets::SpiderGazelle::EventManager.pub_sub = app.websockets_pub_sub
        elsif defined?(::Faye::WebSocket)
          require 'padrino-websockets/faye'
          ::Faye::WebSocket.load_adapter('thin') if defined?(::Thin)
          require 'padrino-websockets/faye/puma-patch' if defined?(Puma)
          app.helpers Padrino::WebSockets::Faye::Helpers
          app.extend Padrino::WebSockets::Faye::Routing
          Padrino::WebSockets::Faye::EventManager.pub_sub = app.websockets_pub_sub
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
