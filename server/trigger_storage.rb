require 'server/trigger'

class TriggerStorage
  class << self
    include Enumerable

    def push(trigger)
      data << trigger
    end

    def each(&block)
      @data.each(&block)
    end

    def data
      @data ||= []
    end
  end
end
