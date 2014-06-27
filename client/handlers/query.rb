module Handlers
  class Query
    def self.fetch(chained_object, options = {})
      self.new(chained_object, options).deferred
    end

    def initialize(chained_object, options)
      @chained_object = chained_object
      @as = options[:as]
    end

    def deferred
      $socket.write(:query, @chained_object.to_hash).tap do |deferred|
        deferred.done do |data|
          Context[@as] = JSON.parse(data)
        end
      end
    end

    private

    def klass
      @chained_object.klass
    end
  end
end