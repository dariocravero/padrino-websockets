# Padrino Websockets

A WebSockets abstraction for the Padrino Ruby Web Framework to manage
    channels, users and events regardless of the underlying WebSockets implementation.

## Current support

* [SpiderGazelle](https://github.com/cotag/spider-gazelle) a LibUV application server.
* [Puma](http://puma.io/) >= 2.0. (*)
* [Thin](http://code.macournoyer.com/thin/)  (*)
* [Rainbows](http://rainbows.rubyforge.org/)  (\*)  (**)
* [Goliath](http://postrank-labs.github.com/goliath/)  (\*) (**)
* [Phusion Passenger](https://www.phusionpassenger.com/) >= 4.0 with nginx >= 1.4  (\*)  (**)

(*) Supported through [faye-websocket-ruby](https://github.com/faye/faye-websocket-ruby).
 
(**) Untested.


## Installation

Add this line to your application's `Gemfile`:

```
gem 'padrino-websockets'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install padrino-websockets
```

## Usage

Add this line to your main application's file (`app/app.rb`):

```
register Padrino::WebSockets
```

Then in any controller or in the app itself, define a WebSocket channel:

```
websocket :channel do
  on :ping do |message|
    send_message({pong: true, data: message})
  end
end
```

How to use it on a browser?

```
var connection = new WebSocket('ws://localhost:3000/channel');

connection.onopen = function(message) {
  console.log('connected to channel');
  connection.send(JSON.stringify({event: 'ping', some: 'data'}));
}

connection.onmessage = function(message) {
  console.log('message', JSON.parse(message.data));
}

// TODO Implement on the backend
connection.onerror = function(message) {
  console.error('channel', JSON.parse(message.data));
}

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/padrino-websockets/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Made with <3 by @dariocravero at [UXtemple](http://uxtemple.com).

Heavily inspired by @stakach's [example](https://github.com/cotag/spider-gazelle/issues/4).
