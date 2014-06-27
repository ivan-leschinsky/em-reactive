require 'server/handlers/ping_handler'
require 'server/handlers/schema_handler'
require 'server/handlers/query_handler'

class Handler

  HANDLERS = {
    "ping" => Handlers::PingHandler,
    "schema" => Handlers::SchemaHandler,
    "query" => Handlers::QueryHandler
  }

  def self.call(raw_data, ws)
    request_data = TransmissionData.from_json(raw_data)
    handler = HANDLERS[request_data.message]
    if handler
      em_ws = EmSocket.new(ws)
      em_ws.uid = request_data.uid
      handler.new(request_data.data, em_ws).call
    else
      puts "Unknown message #{request_data.message} with data #{raw_data}"
    end
  end
end