require! {
  '../common'
  './chunk_loader' : {ChunkLoader}
  './mesh/manager' : {Manager}
  './map'    : {Map}
  './camera' : {Camera}
  './player' : {Player}
  './mesher' : {CullingChunkMesher, GreedyChunkMesher, SampleChunks}
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
    #@loader               = new ChunkLoader @game.socket, @map, pos
    @player               = new Player @scene, @socket, @camera

    # camera_pos            = new bjs.Vector3(pos.x, pos.y, pos.z)
    camera_pos            = new bjs.Vector3(0, 0, -10)
    @camera               = new Camera('camera1', camera_pos, @scene, @game.inputs)
      ..setTarget bjs.Vector3.Zero! #new bjs.Vector3(pos.x, pos.y, pos.z + 1)
    #  ..on_pos_change @loader~on_pos_change
    #@camera.events.on 'chunk-change', @loader~on_chunk_change

    @mesher = new GreedyChunkMesher SampleChunks.random(16, 0.4)
    #@mesher = new GreedyChunkMesher SampleChunks.cube(8, 5)
    @mesher.generate(bjs.Vector3.Zero!, @scene)
    mat = new bjs.StandardMaterial 'test_material', @scene
    #mat.wireframe = true
    box = bjs.Mesh.CreateBox('sddsf', {height:1, width:1, depth:1}, @scene)
    box.material = mat
    tex = new bjs.Texture('textures/blocks/dirt.png', @scene, true, false,
                          bjs.Texture.NEAREST_SAMPLINGMODE)
    mat.ambientTexture = tex
    mat.specularColor = new bjs.Color3 0,0,0
    mat.diffuseColor = new bjs.Color3 1,1,1
    mat.disableLighting = true
    mesh = @mesher.mesh @scene
    mesh.position = bjs.Vector3.Zero!
    mesh.material = mat

    @engine.runRenderLoop @scene~render

  tick: ->
    @camera.tick!
