class DeferredPool
  def initialize
    @pool = []
  end

  def <<(deferred)
    @pool << deferred
  end

  def ready(&block)
    pool = @pool.dup
    @pool.each_with_index do |deferred, index|
      deferred.done do
        pool[index] = nil
        block.call if pool.all?(&:nil?)
      end
    end
  end
end