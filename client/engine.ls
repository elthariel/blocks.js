require! {
  '../common'
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
  './map'    : {Map}
  './camera' : {Camera}
  './player' : {Player}
}

export class Engine
  (@game) ->

  start: (pos) ->
    pos                   = common.pos.world_pos(pos.x, pos.y, pos.z)

    @engine               = new bjs.Engine @game.canvas

    clear_color           = new bjs.Color3(0.22, 0.6, 1.0)
    @scene                = new bjs.Scene @engine
      ..clearColor        = clear_color
      ..gravity           = new bjs.Vector3 0 -0.01 0
      ..collisionsEnabled = true

      # Set up a nice fog in the distrance to hide chunk load/unload
      ..fogEnabled        = true
      ..fogMode           = bjs.Scene.FOGMODE_LINEAR
      ..fogColor          = clear_color
      ..fogDensity        = 0.2
      ..fogStart          = 1.5 * 32
      ..fogEnd            = 2 * 32

    light_pos             = new bjs.Vector3(0,1,0)
    @light                = new bjs.HemisphericLight 'light1', light_pos, @scene

    Manager.scene @scene
    @map                  = new Map @scene, @game.socket
    @loader               = new ChunkLoader @game.socket, @map, pos
    @player               = new Player @scene, @socket, @camera

    camera_pos            = new bjs.Vector3(pos.x, pos.y, pos.z)
    @camera               = new Camera('camera1', camera_pos, @scene, @game.inputs)
      ..setTarget new bjs.Vector3(pos.x, pos.y, pos.z + 1)
      ..events.on 'chunk-change', @loader~on_chunk_change

    @engine.runRenderLoop @scene~render

  tick: ->
    @camera.tick!
