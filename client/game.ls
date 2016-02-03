require! {
  '../common'
  './map' : {Map}
  './camera' : {Camera}
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
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


    @scene                = new bjs.Scene @engine

      # ..gravity           = new BABYLON.Vector3 0 -9.81 0
      # ..collisionsEnabled = true
      ..debugLayer.show!

    #FIXME
    common.blocks.Base.initialize @scene

    @map                  = new Map @scene, @socket
    light                 = new bjs.HemisphericLight 'light1', new bjs.Vector3(0,1,0), @scene
    @loader               = new ChunkLoader @socket, @map, @pos

    @camera               = new Camera 'camera1', new bjs.Vector3(@pos.x, @pos.y, @pos.z), @scene
      # ..applyGravity      = true
      # ..checkCollisions   = true
      ..setTarget bjs.Vector3.Zero!
      ..attachControl @canvas, false
      ..keysUp            = [87]
      ..keysDown          = [83]
      ..keysRight         = [68]
      ..keysLeft          = [65]
      ..on_pos_change @loader~on_pos_change

    @player               = new Player @scene, @socket, @camera

    # Manager.scene(@scene)
    # i = Manager.instance(3, 'test')
    # i.visible = true
    # i.position = bjs.Vector3.Zero!
    # console.log i
    @engine.runRenderLoop @scene~render

    # @manage_lock!

    # bjs.SceneOptimizer.OptimizeAsync @scene, bjs.SceneOptimizerOptions.ModerateDegradationAllowed!, (->), (->)
    # @engine.isPointerLock = true
