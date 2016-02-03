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
      @socket.once \welcome, @~start
      @socket.emit \hello @login

  start: (pos) ->
    @pos = common.pos.world_pos(pos.x, pos.y, pos.z)
    @canvas = document.getElementById \renderCanvas
    @engine = new bjs.Engine @canvas
    @scene = scene @engine
    # @camera = new Camera
    # @light = new Light
    @map = new Map
    # @player = new Player pos
    camera = new Camera 'camera1', new bjs.Vector3(0, 5, 5), @scene
    camera.setTarget bjs.Vector3.Zero!
    camera.attachControl @canvas, false

    Manager.scene(@scene)
    i = Manager.instance(0, 'test')
    i.position = bjs.Vector3(0, 0, 0)

    @loader = new ChunkLoader @socket, @map, @pos
    camera.on_pos_change @loader~on_pos_change

    light = new bjs.HemisphericLight 'light1', new bjs.Vector3(0,1,0), @scene

    #@scene.createOrUpdateSelectionOctree();
    @engine.runRenderLoop @scene~render
