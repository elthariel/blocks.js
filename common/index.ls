require! {
  # The magic module
  './consts'

  # Submodules
  './mixins'

  # Classes
  './blocks'
  './chunk'
  './map'
  './packed_bits'
  './player'
  './pos'
  './registry'
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
  packed_bits.PackedBitsArray
  player.Player
  pos
  registry.Registry
}
