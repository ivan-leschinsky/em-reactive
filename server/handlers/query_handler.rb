module Handlers
  class QueryHandler

    def initialize(data, ws)
      puts ws.object_id
      @data = data
      @ws = ws
    end

    def call
      puts self.inspect

      Fiber.new {
        @query_result = klass
        each_query_method do |method_name, args|
          @query_result = @query_result.send(method_name, *args)
        end
        set_triggers
        @ws.write(:response, @query_result.to_json)
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

    def set_triggers
      return unless record_ids.any?
      trigger = Trigger.new(@ws, klass, record_ids, @data["as"])
      TriggerStorage.push(trigger)
      puts "Triggers:"
      TriggerStorage.each do |trigger|
        puts trigger.inspect
      end
    end

    def record_ids
      @record_ids ||= begin
        collection = @query_result.is_a?(ActiveRecord::Base) ? [@query_result] : @query_result
        collection.map(&:id) rescue []
      end
    end

    def trigger_storage
      @ws.triggers[klass] ||= []
    end

  end
end