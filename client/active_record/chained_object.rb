module ActiveRecord
  class ChainedObject

    def initialize(klass)
      @klass = klass
    end
    attr_reader :klass

    attr_writer :data
    def data
      @data ||= []
    end

    def with(method_name, args)
      data << {
        method: method_name,
        args: args
      }
      self
    end

    def self.with(klass, method_name, args)
      new(klass).with(method_name, args)
    end

    def to_hash
      { klass: @klass, data: data }
    end

    def method_missing(method_name, *args)
      if ActiveRecord::METHODS.include?(method_name.to_s)
        with(method_name, args)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      ActiveRecord::METHODS.include?(method_name) || super
    end
  end
end