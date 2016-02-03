require! {
  '../common'
  './scene'
  './map' : {Map}
  './camera' : {Camera}
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
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

  start: (pos) ->
    @canvas               = document.getElementById \renderCanvas
    @engine               = new bjs.Engine @canvas

    @scene                = new bjs.Scene @engine
      ..gravity           = new BABYLON.Vector3 0 -9.81 0
      ..collisionsEnabled = true
      ..debugLayer.show!

    #FIXME
    BlockCommon.Base.initialize @scene

    light                 = new bjs.HemisphericLight 'light1', new bjs.Vector3(0,1,0), @scene

    @camera               = new bjs.FreeCamera 'camera1', new bjs.Vector3(pos.x, pos.y, pos.z), @scene
      ..applyGravity      = true
      ..checkCollisions   = true
      ..setTarget bjs.Vector3.Zero!
      ..attachControl @canvas, false
      ..keysUp            = [87]
      ..keysDown          = [83]
      ..keysRight         = [68]
      ..keysLeft          = [65]

    @map                  = new Map @scene, @socket
    @player               = new Player @scene, @socket, @camera

    @engine.runRenderLoop @scene~render
    # bjs.SceneOptimizer.OptimizeAsync @scene, bjs.SceneOptimizerOptions.ModerateDegradationAllowed!, (->), (->)
