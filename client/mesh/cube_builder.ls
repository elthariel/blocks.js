
console.log bjs

export cube_builder = (scene, data) ->
  opts =
    width: 1
    height:1
    depth: 1

  box = bjs.Mesh.CreateBox(data.name, opts, scene)
  box.visible = false
  material = new bjs.StandardMaterial("#{data.name}_material", scene)
  mesh.material.diffuseColor = new BABYLON.Color3 0 0 0
  mesh.material.specularColor = new BABYLON.Color3 0 0 0
  mesh.material.ambientColor = new BABYLON.Color3 1 1 1
  box.material = material

  if data.alpha
   material.alpha = data.alpha

  if data.texture?
    tex = new bjs.Texture('textures/' + data.texture, scene)
    material.diffuseTexture = tex

  box
