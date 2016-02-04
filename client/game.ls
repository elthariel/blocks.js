require! {
  'events' : EventEmitter
  '../common'
  './map' : {Map}
  './camera' : {Camera}
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
  './player' : {Player}
}

export class Game extends EventEmitter
  keys:
    left: ['left', 'A']
    right: ['right', 'D']
    up: ['up', 'W']
    down: ['down', 'S']
    jump: ['space']
  slowkeys:
    grab_cursor: ['G']
    fullscreen: ['F']
  login: \champii
  options: {}

  ->
    console.log  'Starting Blocks...'

    @tick = 0
    @shell = require('game-shell')(@options)
    @shell.on 'init' @~on_init
    @shell.on 'tick' @~on_tick

  on_init: ->
    console.log 'Game Shell initialized'
    @canvas = document.createElement('canvas')
    @canvas.style.width = '100%'
    @canvas.style.height = '100%'
    @shell.element.appendChild(@canvas)
    @bind_keys!

    @socket = io!
    @handshake!

  handshake: ->
    @socket.on \hello ~>
      @socket.once \welcome @~start
      @socket.emit \hello @login

  bind_keys: ->
    for name, binding of @keys
      @shell.bind.apply(@shell, [name].concat(binding))
    for name, binding of @slowkeys
      @shell.bind.apply(@shell, [name].concat(binding))

    @on 'key:grab_cursor', ~>
      @shell.pointerLock = not @shell.pointerLock
    @on 'key:fullscreen', ~>
      @shell.fullscreen = not @shell.fullscreen

  on_tick: ->
    @tick++
    @process_inputs!

  process_inputs: ->
    for name, b of @keys
      if @shell.wasDown name
        console.log "Pressed key:#{name}"
        @emit "key:#{name}"
    for name, b of @slowkeys
      if @tick %% 5 == 0 and @shell.wasDown name
        console.log "Pressed slowkey:#{name}"
        @emit "key:#{name}"

    dx = @shell.mouseX - @shell.prevMouseX
    dy = @shell.mouseY - @shell.prevMouseY
    if dx or dy
      console.log "mouse:move #{dx} #{dy}"
      @emit "mouse:move", dx, dy

  start: (pos) ->
    @pos                  = common.pos.world_pos(pos.x, pos.y, pos.z)
    @engine               = new bjs.Engine @canvas

    clear_color = new bjs.Color3(0.22, 0.6, 1.0)
    @scene                = new bjs.Scene @engine
      ..clearColor        = clear_color
      ..gravity           = new bjs.Vector3 0 -0.01 0
      ..collisionsEnabled = true
      ..debugLayer.show!

      ..fogEnabled        = true
      ..fogMode           = bjs.Scene.FOGMODE_LINEAR
      ..fogColor          = clear_color
      ..fogDensity        = 0.2
      ..fogStart          = 1.5 * 32
      ..fogEnd            = 2 * 32

    Manager.scene @scene

    @map                  = new Map @scene, @socket
    light                 = new bjs.HemisphericLight 'light1', new bjs.Vector3(0,1,0), @scene
    @loader               = new ChunkLoader @socket, @map, @pos

    @camera               = new Camera 'camera1', new bjs.Vector3(@pos.x, @pos.y, @pos.z), @scene
      # ..applyGravity      = true
      # ..checkCollisions   = true
      ..setTarget new bjs.Vector3(@pos.x, pos.y, pos.z + 1)
      ..on_pos_change @loader~on_pos_change

    @player               = new Player @scene, @socket, @camera
    @engine.runRenderLoop @scene~render
