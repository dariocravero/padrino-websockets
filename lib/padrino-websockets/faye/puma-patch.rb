module Faye
  class RackStream
    def initialize(socket_object)
      @socket_object = socket_object
      @connection    = socket_object.env['em.connection']
      @stream_send   = socket_object.env['stream.send']

      if socket_object.env['rack.hijack']
        socket_object.env['rack.hijack'].call
        @rack_hijack_io = socket_object.env['rack.hijack_io'] || socket_object.env['puma.socket']
        EventMachine.attach(@rack_hijack_io, Reader) do |reader|
          @rack_hijack_io_reader = reader
          reader.stream = self
        end
      end

      @connection.socket_stream = self if @connection.respond_to?(:socket_stream)
    end
  end
end
