
class HasEvents
  register_socket: (socket) ->
    socket.on '*', (type, msg) ->
      @_on_event(type, msg)

  _on_event: (type, msg) ->
    handler_name = "on_#{name}"
    this[handler_name](object)

  emit: (type, msg) ->
      @socket.emit(type, msg)

module.exports = HasEvents
