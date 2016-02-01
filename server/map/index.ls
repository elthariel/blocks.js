require! {
  \../../common
  \./world_generator : {WorldGenerator}
  \./seed : {Seed}
}

class Map extends common.Map
  ->
    @seed = Seed.generate!
    @generator = new WorldGenerator(@seed)

  chunk_missing: (cid) ->
    console.log "Generating a new chunk for id #{cid}"
    @generator.generate_chunk(cid)

module.exports = {Map}
