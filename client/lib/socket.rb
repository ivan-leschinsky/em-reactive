class Socket
  SUPPORTED_EVENTS = [:open, :message, :close]

  def initialize(endpoint)
    @websocket = Browser::Socket.new(endpoint)
    @message_callbacks = {}

    initialize_events!
  end

  def on_open(e)
    Evented.run(:socket, :ready)
    start_ping
  end

  def on_message(e)
    puts e.data.inspect
    data = TransmissionData.from_json(e.data)
    if data.message == "_notification"
      Handlers::Notification.new(data).call
    else
      @message_callbacks[data.uid].resolve(data)
    end
  end

  def on_close(e)
    puts "on close #{e}"
  end

  def write(message, data = {})
    data = TransmissionData.new(message, data)
    @websocket.write(data.to_json)
    @message_callbacks[data.uid] = Deferred.new
  end

  private

  def initialize_events!
    SUPPORTED_EVENTS.each do |event_name|
      @websocket.on event_name do |e|
        send("on_#{event_name}", e)
      end
    end
  end

  def start_ping
    every(10) { write(:ping) }
  end
end
