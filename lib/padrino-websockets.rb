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
        else
          logger.error "Can't find a WebSockets backend. At the moment we only support SpiderGazelle."
          raise NotImplementedError
        end

        app.helpers Padrino::WebSockets::Helpers
      end
      alias :included :registered
    end
  end
end
