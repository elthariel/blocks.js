
HasEvents =
  register_socket: (socket) ->
    socket.on '*', (type, msg) ~>
      @_on_event(type, msg)

  _on_event: (data) ->
    type = data.data[0]
    msg = data.data[1]
    handler_name = "on_#{type}"
    if this[handler_name]?
      this[handler_name](msg)
    else
      console.log "Missing hanlder for msg #{type}"
      console.log type

  emit: (type, msg) ->
      @socket.emit(type, msg)

module.exports = HasEvents
