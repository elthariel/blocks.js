require! {
  \../common/Block : BlockCommon
  # \./HasMesh
  \./scene

}

meshNb = 1

redFaces = ->
  color = [0 0 0 1]
  color.0 = Math.random!
  color.1 = Math.random!
  color.2 = Math.random!

  faceColors = new Array 6
  for _, i in faceColors
    faceColors[i] = new bjs.Color4 color.0, color.1, color.2, 1

BlockCommon::deported_ctor = (x, y, z) ->
  opts =
    width: 1
    height: 1
    depth: 1,
    # faceColors : redFaces!
  @mesh = new bjs.Mesh.CreateBox "mesh#{meshNb++}" opts, scene!

  @mesh.position <<< {x, y, z}
  @mesh.faceColors = redFaces!


module.exports = BlockCommon
