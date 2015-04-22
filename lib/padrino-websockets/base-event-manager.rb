module Padrino
  module WebSockets
    class BaseEventManager
      require 'oj'

      ERRORS = {
        parse_message: "Can't parse the WebSocket's message",
        message_format: "Wrong message format. Expected: {event: 'ev', p1: 'p1', ...}",
        unsupported_event: "The event you requested isn't supported",
        runtime: "Error while running the event handler"
      }

      ##
      # Creates a new WebSocket manager for a specific connection with a user on a channel.
      #
      # It will listen for specific events and run their blocks whenever a WebSocket call on
      # that channel comes through.
      #
      # == Params
      # * `channel`: The name of the channel
      # * `user`: Unique string to ID the user. See the `set_websocket_user` helper.
      # * `ws`: The WebSocket promise/reactor/etc - whatever keeps it alive for this user.
      # * `event_context`: The Padrino application controller's context so that it can access the
      #   helpers, mailers, settings, etc. Making it a first-class citizen as a regular HTTP 
      #   action is. TODO Review it though, it's probably wrong.
      # * `&block`: A block with supported events to manage.
      #
      def initialize(channel, user, ws, event_context, &block)
        @channel = channel
        @user = user
        @ws = ws
        @@connections ||= {}
        @@connections[@channel] ||= {}
        @@connections[@channel][@user] = @ws

        @events = {}

        @event_context = event_context

        instance_eval &block if block_given?
      end

      ##
      # DSL for adding events from the events block
      #
      def event(name, &block)
        @events[name.to_sym] = block if block_given?
      end
      alias :on :event

      ##
      # Message receiver
      #
      def on_message(data, ws)
        # TODO Detect external ws hijack and drop it
        begin
          # Parse the message
          message = ::Oj.load data

          # Check if we have well formed message, i.e., it includes at least an event name.
          event = message.delete 'event'

          if event.nil?
            logger.error ERRORS[:message_format]
            logger.error e.message
            logger.error e.backtrace.join("\n")

            return send_message({error: {
              name: :message_format,
              message: ERRORS[:message_format]
            }})
          end

          event = event.to_sym

          # Check if it's a valid event
          unless @events.include?(event)
            logger.error ERRORS[:unsupported_event]
            logger.error e.message
            logger.error e.backtrace.join("\n")

            return send_message({error: {
              name: :unsupported_event,
              message: ERRORS[:unsupported_event],
              event: event
            }})
          end

          # Call it
          # TODO Make the params (message) available through the params variable as we do
          # in normal actions.
          logger.debug "Calling event: #{event} as user: #{@user} on channel #{@channel}."
          logger.debug message.inspect
          # Run the event in the context of the app
          @event_context.instance_exec message, &@events[event]
        rescue Oj::ParseError => e
          logger.error ERRORS[:parse_message]
          logger.error e.message
          logger.error e.backtrace.join("\n")

          send_message({error: {
            name: :parse_message,
            message: ERRORS[:parse_message]
          }})
        rescue => e
          logger.error ERRORS[:runtime]
          logger.error e.message
          logger.error e.backtrace.join("\n")

          send_message({error: {
            name: :runtime,
            message: ERRORS[:runtime],
            event: event,
            exception: {
              message: e.message,
              backtrace: e.backtrace
            }
          }})
        end
      end

      ##
      # Manage the WebSocket's connection being closed.
      #
      def on_shutdown
        logger.debug "Disconnecting user: #{@user} from channel: #{@channel}."
        @@connections[@channel].delete(@user)
      end

      class << self
        ##
        # Broadcast a message to the whole channel.
        # Can be used to access it outside the router's scope, for instance, in a background process.
        #
        def broadcast(channel, message, except=[])
          logger.debug "Broadcasting message on channel: #{channel}. Message:"
          logger.debug message
          @@connections[channel].each do |user, ws|
            next if except.include?(user)
            write message, ws
          end
        end

        ##
        # Send a message to a user on the channel
        # Can be used to access it outside the router's scope, for instance, in a background process.
        #
        def send_message(channel, user, message)
          logger.debug "Sending message: #{message} to user: #{user} on channel: #{channel}. Message"
          write message, @@connections[channel][user]
        end

        ##
        # Write a message to the WebSocket.
        #
        # It's a wrapper around the different WS implementations.
        # This has to be implemented for each backend.
        def write(message, ws)
          logger.error "Override the write method on the WebSocket-specific backend."
          raise NotImplementedError
        end
      end

      protected
        ##
        # Maintain the connection if ping frames are supported
        #
        def on_open(event)
          logger.debug "Connection openned as user: #{@user} on channel: #{@channel}."
        end
    end
  end
end
