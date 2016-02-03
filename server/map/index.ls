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
    common.log_time "Generation of chunk #{cid} took", ~>
      console.log "Generating chunk #{cid}"
      @set cid, @generator.generate_chunk(cid)

module.exports = {Map}
