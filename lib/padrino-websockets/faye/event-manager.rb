module Padrino
  module WebSockets
    module Faye
      class EventManager < BaseEventManager
        def initialize(channel, user, ws, event_context, &block)
          ws.on :open do |event|
            self.on_open event #&method(:on_open)
          end
          ws.on :message do |event|
            self.on_message event.data, @ws
          end
          ws.on :close do |event|
            self.on_shutdown event # method(:on_shutdown)
          end

          super channel, user, ws, event_context, &block
        end

        ##
        # Manage the WebSocket's connection being closed.
        #
        def on_shutdown(event)
          @pinger.cancel if @pinger
        end

        ##
        # Write a message to the WebSocket.
        #
        def self.write(message, ws)
          ws.send ::Oj.dump(message)
        end

        protected
          ##
          # Maintain the connection if ping frames are supported
          #
          def on_open(event)
            super event

            @ws.ping('pong')
          end
      end
    end
  end
end
