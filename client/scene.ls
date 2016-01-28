scene = null

module.exports = (engine) ->
  if not scene? and engine?
    scene := new bjs.Scene engine

  scene
