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
    console.log 'Chunk !' chunk
    newChunk = new ndarray flatten(chunk.blocks), [32 32 32]
    game.voxels.chunks[chunk.position.join('|')] = newChunk
    game.showChunk newChunk
    idx = find-index (-> it is chunk.position.join('|')), game.pendingChunks
    game.pendingChunks.splice idx, 1 if idx?

  socket.on \hello ->
    socket.on \welcome avatar.yaw.position~set
    socket.emit \hello \champii


start-game = ->

  Game::loadPendingChunks = (count) ->
    if !@asyncChunkGeneration
      count = @pendingChunks.length
    else
      count = count || (@pendingChunks.length * 0.1)
      count = Math.max(1, Math.min(count, @pendingChunks.length))

    for i from 0 til count
      chunkPos = @pendingChunks[i].split('|')
      @voxels.asyncLoadChunk chunkPos[0] .|. 0, chunkPos[1] .|. 0, chunkPos[2] .|. 0

  game := Game do
    generateChunks: false
    mesher: voxel.meshers.greedy
    chunkDistance: 4
    materials: <[#888]>
    materialFlatColor: true
    worldOrigin: [0 0 0]
    controls: discreteFire: true

  game.voxels.asyncLoadChunk = (x, y, z, done) ->
    console.log 'ask Chunk !' {x, y, z}
    socket.emit 'get_chunk' {x, y, z}

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
start-game!
