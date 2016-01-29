# require! <[ ./Map ./Player ]>
require! {
  \./scene
  \./Map
}


class Game

  login: \champii

  ->
    @socket = io!
    @handshake!

  handshake: ->
    @socket.on \hello ~>
      @socket.once \welcome @~start
      @socket.emit \hello @login

  start: (pos) ->
    @canvas = document.getElementById \renderCanvas
    @engine = new bjs.Engine @canvas
    @scene = scene @engine
    # @camera = new Camera
    # @light = new Light
    @map = new Map
    # @player = new Player pos
    camera = new bjs.FreeCamera 'camera1', new bjs.Vector3(0, 5,-10), @scene

    camera.setTarget bjs.Vector3.Zero!

    camera.attachControl @canvas, false

    light = new bjs.HemisphericLight 'light1', new bjs.Vector3(0,1,0), @scene

    # bjs.SceneOptimizer.OptimizeAsync @scene, bjs.SceneOptimizerOptions.ModerateDegradationAllowed!, (->), (->)
    @scene.createOrUpdateSelectionOctree();
    @engine.runRenderLoop @scene~render

module.exports = new Game
