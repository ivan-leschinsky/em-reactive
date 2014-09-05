class Trigger
  attr_reader :ws, :klass, :ids, :name

  def initialize(ws, klass, ids, name)
    @ws = ws
    @klass = klass
    @ids = ids
    @name = name
  end

  def applicable_for?(record)
    record.instance_of?(@klass) && @ids.include?(record.id)
  end

  def notify_client(record)
    @ws.write(:_notification, data: record.attributes, as: @name)
  end

  def inspect
    "#<Trigger id:#{@ws.object_id} klass:#{klass.name} ids:#{ids.inspect} name:#{@name}>"
  end
end