$: << File.expand_path("..", __FILE__)

require 'faye/websocket'
require 'active_record'
require 'pry'
require 'em-synchrony'
require 'rack'
require 'opal'
require 'rack/contrib'

require 'opal/browser'
require 'opal-jquery'
require 'server/handler'
require 'server/em_socket'

Opal.append_path File.expand_path("../shared", __FILE__)

require 'shared/lib/transmission_data'
require 'shared/lib/uid'

require "em-synchrony/mysql2"
require "em-synchrony/activerecord"

ActiveRecord::Base.establish_connection(adapter: 'em_mysql2', database: 'testdb', pool: 10, username: 'root', password: '')
ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'shared/models/post'

class WsApp
  def self.call(env)
    if Faye::WebSocket.websocket?(env)
      puts "Ws request!!!"

      ws = Faye::WebSocket.new(env)

      puts "On open"

      ws.on :message do |event|
        Handler.call(event.data, ws)
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end

      ws.rack_response
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
