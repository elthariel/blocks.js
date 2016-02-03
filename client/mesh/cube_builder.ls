
console.log bjs

export cube_builder = (scene, data) ->
  opts = {size: 1}

  box = bjs.Mesh.CreateBox(data.name, {size: 1}, scene)
  box.position = bjs.Vector3.Zero!
  box.visible = false
  material = new bjs.StandardMaterial("#{data.name}_material", scene)
  box.material = material

  if data.alpha?
    material.alpha = data.alpha

  if data.texture?
    tex = new bjs.Texture('textures/' + data.texture, scene)
    material.diffuseTexture = tex

  box
