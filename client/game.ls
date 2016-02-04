require! {
  '../common'
  './map' : {Map}
  './camera' : {Camera}
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
  './player' : {Player}
}

export class Game

  login: \champii

  ->
    @socket = io!
    @handshake!

  handshake: ->
    @socket.on \hello ~>
      @socket.once \welcome @~start
      @socket.emit \hello @login

  ### Dont work:

  # have_pointer_lock: ->
  #   'pointerLockElement' in @canvas ||
  #   'mozPointerLockElement' in @canvas ||
  #   'webkitPointerLockElement' in @canvas
  #
  # manage_lock: ->
  #   @canvas.onclick = ~>
  #     if @have_pointer_lock!
  #       @canvas.requestPointerLock = @canvas.requestPointerLock ||
  #                                    @canvas.mozRequestPointerLock ||
  #                                    @canvas.webkitRequestPointerLock
  #
  #       @canvas.requestPointerLock()
  #
  #       lockError = console~error
  #
  #       document.addEventListener('pointerlockerror', lockError, false);
  #       document.addEventListener('mozpointerlockerror', lockError, false);
  #       document.addEventListener('webkitpointerlockerror', lockError, false);
  #     else
  #       console.log 'Pas de pointerlock'

  start: (pos) ->
    @pos                  = common.pos.world_pos(pos.x, pos.y, pos.z)

    @canvas               = document.getElementById \renderCanvas


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
      ..attachControl @canvas, false
      ..keysUp            = [87]
      ..keysDown          = [83]
      ..keysRight         = [68]
      ..keysLeft          = [65]
      ..on_pos_change @loader~on_pos_change

    @player               = new Player @scene, @socket, @camera
    @engine.runRenderLoop @scene~render

    # @manage_lock!

    # bjs.SceneOptimizer.OptimizeAsync @scene, bjs.SceneOptimizerOptions.ModerateDegradationAllowed!, (->), (->)
    # @engine.isPointerLock = true
