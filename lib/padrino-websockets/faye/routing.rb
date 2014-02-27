module Padrino
  module WebSockets
    module Faye
      module Routing
        require 'faye/websocket'

        ##
        # Creates a WebSocket endpoint using SpiderGazelle + libuv.
        #
        # It handles upgrading the HTTP connection for you.
        # You can nest this inside controllers as you would do with regular actions in Padrino.
        #
        def websocket(channel, *args, &block)
          get channel, *args do
            # Let some other action try to handle the request if it's not a WebSocket.
            throw :pass unless ::Faye::WebSocket.websocket?(request.env)

            set_websocket_user
            puts request.env['rack.hijack_io']
            ws = ::Faye::WebSocket.new(request.env, nil, {ping: 15})
            Padrino::WebSockets::Faye::EventManager.new(channel, session['websocket_user'],
                                                        ws, self, &block)
            ws.rack_response
          end
        end
        alias :ws :websocket
      end
    end
  end
end
