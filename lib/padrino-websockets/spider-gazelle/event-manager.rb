module Padrino
  module WebSockets
    module SpiderGazelle
      class EventManager < BaseEventManager
        def initialize(channel, user, ws, event_context, &block)
          ws.progress method(:on_message)
          ws.finally method(:on_shutdown)
          ws.on_open method(:on_open)

          super channel, user, ws, event_context, &block
        end

        ##
        # Manage the WebSocket's connection being closed.
        #
        def on_shutdown
          @pinger.cancel if @pinger
          super
        end

        ##
        # Write a message to the WebSocket.
        #
        def self.write(message, ws)
          ws.text ::Oj.dump(message)
        end

        # protected
        #   ##
        #   # Maintain the connection if ping frames are supported
        #   #
        #   def on_open(event)
        #     super event

        #     if @ws.ping('pong')
        #       variation = 1 + rand(20000)
        #       binding.pry
        #       @pinger = @ws.loop.scheduler.every 40000 + variation, method(:do_ping)
        #     end
        #   end

        #   ##
        #   # Ping the WebSocket connection
        #   #
        #   def do_ping(time1, time2)
        #     @ws.ping 'pong'
        #   end
      end
    end
  end
end
