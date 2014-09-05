class EmSocket < DelegateClass(Faye::WebSocket)

  attr_accessor :uid

  def write(message, data)
    json = { uid: uid, data: data, message: message }.to_json
    __getobj__.send(json)
  end

  def object_id
    __getobj__.object_id
  end

  def hash
    __getobj__.object_id
  end

  def eql?(ws)
    self.object_id == ws.object_id
  end

  def triggers
    TriggerStorage[self] ||= {}
  end

end