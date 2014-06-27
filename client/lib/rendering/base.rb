module Rendering
  class Base
    def run
      pool = DeferredPool.new
      rendering_methods.each do |method_name|
        chained_object = send(method_name)
        pool << Handlers::Query.fetch(chained_object, as: method_name)
      end
      pool.ready do
        Evented.run(:context, :ready)
      end
    end

    private

    def rendering_methods
      self.class.instance_methods(false)
    end
  end
end