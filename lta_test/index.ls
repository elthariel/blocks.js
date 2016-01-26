window import require \prelude-ls
require! {
  'babylonjs/babylon.max.js' : bjs
  handjs
  \./client.ls
  \../common/pos.ls
}

#bjs = babylonjs.max
canvas = document.querySelector('#renderCanvas')
console.log canvas
engine = new bjs.Engine(canvas, true)

createScene = ->
  # Now create a basic bjs Scene object
  scene = new bjs.Scene(engine)
  # Change the scene background color to green.
  scene.clearColor = new bjs.Color3(0, 1, 0)
  # This creates and positions a free camera
  camera = new bjs.FreeCamera("camera1", new bjs.Vector3(0, 5, -10), scene)
  # This targets the camera to scene origin
  camera.setTarget(bjs.Vector3.Zero());
  # This attaches the camera to the canvas
  camera.attachControl(canvas, false);
  # This creates a light, aiming 0,1,0 - to the sky.
  light = new bjs.HemisphericLight("light1", new bjs.Vector3(0, 1, 0), scene);
  # Dim the light a small amount
  light.intensity = 0.5
  # Let's try our built-in 'sphere' shape. Params: name, subdivisions, size, scene
  box = bjs.Mesh.CreateBox("sphere1", 1, scene)
  # Move the sphere upward 1/2 its height
  box.position.y = 1

  box.material = new bjs.StandardMaterial('text1', scene)
  box.material.diffuseTexture = new bjs.Texture('textures/blocks/cobblestone.png', scene)
  # Let's try our built-in 'ground' shape.  Params: name, width, depth, subdivisions, scene
  ground = bjs.Mesh.CreateGround("ground1", 6, 6, 2, scene)
  # Leave this function
  scene

client.Client.connect (c) ->
  # [cid, _] = client.pos.to_chunk!
  # client.chunk cid, (block) ->
  #   console.log block

  scene = createScene!
  engine.runRenderLoop ->
    scene.render!
