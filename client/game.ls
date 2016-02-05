require! {
  '../common'
  './inputs' : {Inputs}
  './engine' : {Engine}
}

export class Game
  bindings:
    'move-left': ['<left>', 'A']
    'move-right': ['<right>', 'D']
    'move-up': ['<up>', 'W']
    'move-down': ['<down>', 'S']
    'move-jump': ['<space>']
    grab_cursor: ['G']
    fullscreen: ['F']
    debug: ['/']
  login: \champii
  options: {}


  ->
    console.log  'Starting Blocks...'

    @inputs = require('game-inputs')(@canvas, {})
    @shell = require('game-shell')(@options)
    @shell.on 'init' @~on_init


  init_dom: ->
    @canvas = document.createElement('canvas')
    @canvas.style.width = '100%'
    @canvas.style.height = '100%'
    @shell.element.appendChild(@canvas)


  on_init: ->
    console.log 'Game Shell initialized!'
    @init_dom!

    console.log "Registering inputs..."
    @initialize_inputs!

    console.log "Connecting to the server..."
    @socket = io!
    @handshake!


  on_connected: (pos) ->
    console.log "Starting Engine..."

    @engine = new Engine @
    @engine.start pos
    @shell.on 'resize', @engine.engine~resize
    @shell.on 'tick', @~on_tick


  initialize_inputs: ->

    for name, keys of @bindings
      @inputs.bind.apply @inputs, [name].concat(keys)

    @inputs.up.on 'grab_cursor', ~>
      @shell.pointerLock = not @shell.pointerLock
    @inputs.up.on 'fullscreen', ~>
      @shell.fullscreen = not @shell.fullscreen
    @inputs.up.on 'debug', ~>
      if @engine.scene.debugLayer.isVisible()
        @engine.scene.debugLayer.hide()
      else
        @engine.scene.debugLayer.show()

  handshake: ->
    @socket.once \hello ~>
      @socket.once \welcome @~on_connected
      @socket.emit \hello @login


  on_tick: ->
    # Engine tick !
    @engine.tick!
    # Reset counters to 0
    @inputs.tick!
