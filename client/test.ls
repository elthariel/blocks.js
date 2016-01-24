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

socket = io!

Game::loadPendingChunks = (count) ->
  if !@asyncChunkGeneration
    count = @pendingChunks.length
  else
    count = count || (@pendingChunks.length * 0.1)
    count = Math.max(1, Math.min(count, @pendingChunks.length))

  for i from 0 til count
    chunkPos = @pendingChunks[i].split('|')
    @voxels.asyncLoadChunk chunkPos[0] .|. 0, chunkPos[1] .|. 0, chunkPos[2] .|. 0, (err, chunk) ~>
      @showChunk(chunk) if @isClient

  @pendingChunks.splice(0, count) if count

game = Game do
  generateChunks: false
  mesher: voxel.meshers.greedy
  chunkDistance: 4
  materials: <[#888]>
  materialFlatColor: true
  worldOrigin: [0 0 0]
  controls: discreteFire: true

game.voxels.asyncLoadChunk = (x, y, z, done) ->
  socket.emit 'get_chunk' {x, y, z}
  socket.on 'chunk' ->
    chunk = new ndarray [], [32 32 32]
    for arr1, x in it
      for arr2, y in arr1
        for val, z in arr2
          chunk.set x, y, z, val.id
    done null, chunk

game.handleChunkGeneration!

game.appendTo document.body

createPlayer = voxel-player game

avatar = createPlayer \./player.png
avatar.possess!
avatar.yaw.position.set 2 14 4

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
