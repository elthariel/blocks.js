require! {
  'events' : EventEmitter
}

export class Inputs extends EventEmitter

  (@shell) ->
    @_ticks = 0
    @bind!

  bind: ->
    for name, binding of @keys
      @shell.bind.apply(@shell, [name].concat(binding))
    for name, binding of @slowkeys
      @shell.bind.apply(@shell, [name].concat(binding))

  tick: ->
    @_ticks++

    for name, _ of @keys
      if @shell.wasDown name
        console.log "Pressed key:#{name}"
        @emit "key:#{name}"

    for name, _ of @slowkeys
      if @_ticks %% 10 == 0 and @shell.wasDown name
        console.log "Pressed slowkey:#{name}"
        @emit "key:#{name}"

    dx = @shell.mouseX - @shell.prevMouseX
    dy = @shell.mouseY - @shell.prevMouseY
    if dx > 0 or dy > 0
      console.log "mouse:move #{dx} #{dy}"
      @emit "mouse:move", dx, dy
