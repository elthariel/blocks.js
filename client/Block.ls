require! {
  \../common/Block : BlockCommon
  # \./HasMesh
  \./blocks_textures : textures
}

mesh = null

createMesh = (name) ->


redFaces = ->
  color = [0 0 0 1]
  color.0 = Math.random!
  color.1 = Math.random!
  color.2 = Math.random!

  faceColors = new Array 6
  for _, i in faceColors
    faceColors[i] = new bjs.Color4 color.0, color.1, color.2, 1

BlockCommon::initialize = (x, y, z) ->
  console.log 'TAMERE' @
  @instance = @@@mesh.createInstance \lol
  @instance.position <<< {x, y, z}
  @instance.isVisible = false
  @instance.checkCollisions = true;

create_mesh = (scene, block) -->
  meshNb = 1
  opts =
    width: 1
    height: 1
    depth: 1

  mesh = new bjs.Mesh.CreateBox block.DisplayName, opts, scene
  mesh.position <<< {x: 0, y: 0, z: 0}
  mesh.isVisible = false
  # scene.ambientColor = new BABYLON.Color3(1, 1, 1);
  mesh.material = new BABYLON.StandardMaterial "material#{meshNb++}", scene
  mesh.material.diffuseColor = new BABYLON.Color3 0 0 0
  mesh.material.specularColor = new BABYLON.Color3 0 0 0
  mesh.material.ambientColor = new BABYLON.Color3 1 1 1
  mesh.material.diffuseTexture = new BABYLON.Texture \/textures/blocks/grass_side.png,  scene
  block.mesh = mesh


BlockCommon.initialize = (@scene) ->
  console.log 'trolilol' @
  each (create_mesh @scene), @registry!


# BlockCommon.Air::deported_ctor = ->
#   super ...
#   @mesh.isVisible = false

# BlockCommon.Ground::deported_ctor = ->
#   super ...
#   @mesh.isVisible = true

module.exports = BlockCommon
