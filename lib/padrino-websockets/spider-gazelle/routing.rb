module Padrino
  module WebSockets
    module SpiderGazelle
      module Routing
        require 'spider-gazelle/upgrades/websocket'

        ##
        # Creates a WebSocket endpoint using SpiderGazelle + libuv.
        #
        # It handles upgrading the HTTP connection for you.
        # You can nest this inside controllers as you would do with regular actions in Padrino.
        #
        def websocket(channel, *args, &block)
          get channel, *args do
            # Let some other action try to handle the request if it's not a WebSocket.
            throw :pass unless request.env['rack.hijack']

            event_context = self

            # It's a WebSocket. Get the libuv promise and manage its events
            request.env['rack.hijack'].call.then do |hijacked|
              ws = ::SpiderGazelle::Websocket.new hijacked.socket, hijacked.env

              set_websocket_user

              Padrino::WebSockets::SpiderGazelle::EventManager.new(
                channel, session['websocket_user'], ws, event_context, &block)
              ws.start
            end
          end
        end
        alias :ws :websocket
      end
    end
  end
end
