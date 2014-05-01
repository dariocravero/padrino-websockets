module PadrinoWebsocketsDemo
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::WebSockets

    enable :sessions

    get :index do
      render :index
    end

    websocket :channel do
      on :test do |message|
        "test on channel"
        send_message :channel, session['websocket_user'], message
        broadcast :channel, message.merge({'broadcast' => true})
      end
    end
  end
end
