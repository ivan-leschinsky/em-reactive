module Handlers
  class SchemaHandler

    def initialize(data, ws)
      @data = data
      @ws = ws
    end

    def call
      Fiber.new { @ws.write(:response, klass.column_names) }.resume
    end

    private

    def klass
      Object.const_get(@data["klass"])
    end

  end
end