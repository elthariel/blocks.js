require! {
  voxel
  \voxel-player
  \voxel-engine : Game
  \voxel-fly
  \voxel-walk
  \voxel-highlight
  ndarray
}

window import require \prelude-ls

game = null
socket = null
avatar = null

set-socket-listeners = ->
  socket := io!

  socket.on 'chunk' (chunk) ->
    pos = [chunk.pos.x, chunk.pos.y, chunk.pos.z].join('|')
    newChunk = {voxels: new Int8Array flatten(chunk.chunk), dims: [32 32 32]}
    # newChunk = game.voxels.generateChunk.apply game.voxels, [chunk.pos.x, chunk.pos.y, chunk.pos.z]
    newChunk.position = [chunk.pos.x, chunk.pos.y, chunk.pos.z]
    console.log 'NEW CHUNK' newChunk
    game.voxels.chunks[pos] = newChunk
    # game.showChunk newChunk

    idx = find-index (-> it === pos), game.pendingChunks
    game.pendingChunks.splice idx, 1 if idx?

  socket.on \hello ->
    socket.on \welcome ({x, y, z}) ->
      start-game!
      avatar.yaw.position.set x, y, z
    socket.emit \hello \champii

start-game = ->

  Game::handleChunkGeneration = ->
    @voxels.on \missingChunk (chunkPos) ~>
      if not find (-> it is chunkPos.join('|')), @pendingChunks
        @pendingChunks.push chunkPos.join('|')
        socket.emit 'get_chunk' {x: chunkPos[0] .|. 0, y: chunkPos[1] .|. 0, z: chunkPos[2] .|. 0}
    @voxels.requestMissingChunks(@worldOrigin)

  game := Game do
    generateChunks: false
    mesher: voxel.meshers.greedy
    chunkDistance: 1
    materials: <[#888]>
    materialFlatColor: true
    worldOrigin: [0 0 0]
    controls: discreteFire: true

  game.handleChunkGeneration!

  game.appendTo document.body

  createPlayer = voxel-player game

  avatar := createPlayer \./player.png
  avatar.possess!

  makeFly = voxel-fly game
  target = game.controls.target!
  game.flyer = makeFly target

  blockPosPlace = blockPosErase = 0
  hl = game.highlighter = voxel-highlight(game, { color: 0xff0000 })
  hl.on 'highlight', (voxelPos) -> blockPosErase := voxelPos
  hl.on 'remove', (voxelPos) -> blockPosErase := null
  hl.on 'highlight-adjacent', (voxelPos) -> blockPosPlace := voxelPos
  hl.on 'remove-adjacent', (voxelPos) -> blockPosPlace = null

  currentMaterial = 1

  game.on 'fire', (target, state) ->
    position = blockPosPlace
    if position
      game.createBlock(position, currentMaterial)
    else
      position = blockPosErase
      if (position) => game.setBlock(position, 0)

  game.on \tick ->
    voxel-walk.render(target.playerSkin)
    vx = Math.abs(target.velocity.x)
    vz = Math.abs(target.velocity.z)
    if (vx > 0.001 || vz > 0.001) => voxel-walk.stopWalking()
    else voxel-walk.startWalking()

set-socket-listeners!
