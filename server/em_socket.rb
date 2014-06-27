class EmSocket < DelegateClass(Faye::WebSocket)

  attr_accessor :uid

  def write(message, data)
    json = { uid: uid, data: data, message: message }.to_json
    __getobj__.send(json)
  end

end