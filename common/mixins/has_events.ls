
export HasEvents =
  register_socket: (socket) ->
    @_socket = socket

  events: (...names) ->
    names |> each (name) ~>
      console.log "Register event #{name}"
      @_socket.on name, (msg) ~>
        @_on_event name, msg

  _on_event: (type, msg) ->
    # console.log type, msg
    handler_name = "on_#{type}"
    if @[handler_name]?
       @[handler_name] msg
    else
      console.log "Missing hanlder for msg #type"
      console.log type

  emit: (type, msg) ->
    @_socket.emit(type, msg)

  once: (type, fun) ->
    @_socket.once type, fun
