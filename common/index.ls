require! {
  # The magic module
  \./consts

  # Submodules
  \./mixins

  # Classes
  \./blocks
  \./chunk
  \./map
  \./player
  \./pos
}


module.exports = {
  mixins
  BlockBase: blocks.Base
  blocks
  chunk.Chunk
  map.Map
  player.Player
  pos
}
