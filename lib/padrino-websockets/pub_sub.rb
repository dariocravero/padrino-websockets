module Padrino
  module WebSockets
    class PubSub

      # default impl is in-memory
      # in order to provide another 

      def initialize
      end

      def event_manager=(event_manager)
        @event_manager = event_manager
      end

      def event_manager()
        @event_manager
      end

      def broadcast(channel, message, except=[])
        @event_manager.broadcast_local(channel, message, except)
      end

      def send_message(channel, user, message)
        @event_manager.send_message_local(channel, user, message)
      end


    end
  end
end