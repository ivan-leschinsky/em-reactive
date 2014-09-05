module Handlers
  class Notification
    def initialize(data)
      @data = data.data
    end

    def call
      records = Context[as]
      records.each_with_index do |item, index|
        if records[index]["id"] == record["id"]
          records[index] = record
        end
      end
      $action.render
    end

    def as
      @data["as"]
    end

    def record
      @data["data"]
    end
  end
end