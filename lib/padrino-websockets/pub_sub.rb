module Padrino
  module WebSockets
    class PubSub

      # default in-memory pubsub other implementations must conform to the same
      # method signatures:
      # event_manager=
      # broadcast
      # send_message

      # hold on to reference of local even manager type
      # use this to forward messages to local websocket connections
      def event_manager=(event_manager)
        @event_manager = event_manager
      end

      # handle broadcast messages
      # note:  alternate implementations should *NOT* send to a pub-sub systems *AND*
      # local event manager.  it causes duplicate message propogation to local websocket
      # connections
      def broadcast(channel, message, except=[])
        @event_manager.broadcast_local(channel, message, except)
      end

      # note:  alternate implementations should *NOT* send to a pub-sub systems *AND*
      # local event manager.  it causes duplicate message propogation to local websocket
      # connections
      def send_message(channel, user, message)
        @event_manager.send_message_local(channel, user, message)
      end
    end
  end
end