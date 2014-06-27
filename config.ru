require File.expand_path("../app.rb", __FILE__)

Faye::WebSocket.load_adapter('thin')

EM.synchrony do

  thin = Rack::Handler.get('thin')

  opal_server = Opal::Server.new { |s|
    s.append_path 'client'

    s.main = 'application'
  }

  ws_server = Rack::Builder.new {
    use Rack::Static, urls: ["/index.html"], root: "public"
    run WsApp
  }

  app = Rack::Cascade.new([ws_server, opal_server])

  thin.run(app, port: 9292)

end