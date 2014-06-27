module Handlers
  class QueryHandler

    def initialize(data, ws)
      @data = data
      @ws = ws
    end

    def call
      puts self.inspect

      Fiber.new {
        query_result = klass
        each_query_method do |method_name, args|
          query_result = query_result.send(method_name, *args)
        end
        @ws.write(:response, query_result.to_json)
      }.resume
    end

    def inspect
      result = "QueryHandler: #{klass}"
      each_query_method do |method_name, args|
        result += ".#{method_name}(#{args.map(&:inspect).join(', ')})"
      end
      result
    end

    private

    def klass
      Object.const_get(@data["klass"])
    end

    def query_methods
      @data["data"]
    end

    def each_query_method(&block)
      query_methods.each do |method_data|
        block.call(method_data["method"], method_data["args"])
      end
    end

  end
end