module PadrinoWebsocketsDemo
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::WebSockets

    enable :sessions

    get :index do
      render :index
    end

    websocket :channel do
      event :test do |context, message|
        "test on channel"
        send_message message
      end
    end
  end
end
