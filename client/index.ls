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
    geometry.faces[i].color.setHex it
    geometry.faces[i + 1].color.setHex it

  {cube, geometry}

renderer = new THREE.WebGLRenderer
renderer.setPixelRatio window.devicePixelRatio
renderer.setSize window.innerWidth, window.innerHeight
document.body.appendChild renderer.domElement

render = ->
  renderer.render scene, camera

render!

document.addEventListener \mousemove ->
  socket.emit \position player.cube.position <<< it{x, y}
  render!

createPlayer = ->
  player = players[it.color] = it{x, y}
  player <<< newCube it.color

fetchOrCreatePlayer = ->
  players[it.color] or createPlayer it

socket = io!

socket.emit \hello
socket.on   \hello -> player := newCube it

socket.on \position ->
  player = fetchOrCreatePlayer it
  player <<< it{x, y}
  render!
