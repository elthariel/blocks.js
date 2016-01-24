window import require \prelude-ls

players = {}
player = {}

camera = new THREE.OrthographicCamera 0, window.innerWidth, 0, window.innerHeight, 1, 1000

scene = new THREE.Scene

newCube = ->
  geometry = new THREE.BoxGeometry 50 50 50

  material = new THREE.MeshBasicMaterial do
    vertexColors: THREE.FaceColors
    overdraw: 0.5

  cube = new THREE.Mesh geometry, material

  scene.add cube

  for , i in geometry.faces by 2
    geometry.faces[i].color.setHex color = Math.random() * 0xFFFFFF
    geometry.faces[i + 1].color.setHex color

  {cube, geometry}

renderer = new THREE.WebGLRenderer
renderer.setPixelRatio window.devicePixelRatio
renderer.setSize window.innerWidth, window.innerHeight
document.body.appendChild renderer.domElement

render = -> renderer.render scene, camera

player = newCube!
render!

document.addEventListener \mousemove ->
  socket.emit \position player.cube.position <<< it{x, y}
  render!

createPlayer = ->
  player = players[it.id] = it
  player <<< newCube!

fetchOrCreatePlayer = ->
  players[it.id?] or createPlayer it

socket = io!

socket.on \position ->
  player = fetchOrCreatePlayer it
  player <<< it{x, y}
  render!
