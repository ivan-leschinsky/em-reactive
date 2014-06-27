module Handlers
  class PingHandler

    def initialize(data, ws)
      @data = data
      @ws = ws
    end

    def call
      puts "Ping from client #{@ws.object_id}"
    end

  end
end