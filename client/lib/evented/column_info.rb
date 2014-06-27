module Evented
  class ColumnInfo
    def self.call
      pool = DeferredPool.new
      ActiveRecord::Base.subclasses.each do |klass|
        pool << deferred_for_class(klass)
      end
      pool.ready do
        Evented.run(:models, :column_info_loaded)
      end
    end

    private

    def self.deferred_for_class(klass)
      $socket.write(:schema, klass: klass.name).tap do |deferred|
        deferred.done do |response|
          klass.column_names = response
        end
      end
    end
  end
end
