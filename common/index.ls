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

log_time = (msg, fun) ->
  console.time(msg)
  res = fun!
  console.timeEnd(msg)
  res


module.exports = {
  blocks
  chunk.Chunk
  log_time
  map.Map
  mixins
  player.Player
  pos
}
