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

            # if @ws.ping('pong')
            #   variation = 1 + rand(20000)
            #   @pinger = @ws.ping 'pong' #loop.scheduler.every 40000 + variation, method(:do_ping)
            # end
          end

          ##
          # Ping the WebSocket connection
          #
          def do_ping(time1, time2)
            @ws.ping 'pong'
          end
      end
    end
  end
end
