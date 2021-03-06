require! {
  './helpers'
}

# bjs.CubeTexture.prototype.getTextureMatrix = ->
#  @_textureMatrix

export cube_builder = (scene, data) ->
  opts =
    width: 1
    height:1
    depth: 1
    updatable: false

  box = bjs.Mesh.CreateBox(data.name, opts, scene)
  box.isVisible = false
  material = new bjs.StandardMaterial("#{data.name}_material", scene)
  material.checkReadyOnlyOnce = true
  # material.diffuseColor = new BABYLON.Color3 0 0 0
  material.specularColor = new BABYLON.Color3 0 0 0
  #material.ambientColor = new BABYLON.Color3 1 1 1
  material.disableLighting = true
  # bjs.StandardMaterial.DiffuseTextureEnabled = false
  box.material = material

  # if data.air
  #   box.checkCollisions = true

  if data.color?
    material.diffuseColor = helpers.color(data.color)

  if data.alpha
   material.alpha = data.alpha

  if data.texture?
    tex = null
    if data.texture instanceof Array
      tex = new bjs.CubeTexture('textures/', scene, data.texture, true)
      tex.coordinatesMode = bjs.Texture.PLANAR_MODE
      material.diffuseTexture = tex
    else
      tex = new bjs.Texture('textures/' + data.texture, scene, true, false,
                            bjs.Texture.NEAREST_SAMPLINGMODE)

      if data.texture_repeat?
        tex.uScale = tex.vScale = data.texture_repeat
      material.ambientTexture = tex

  box
