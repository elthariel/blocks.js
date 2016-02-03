require! {
  \../../common
  \./world_generator : {WorldGenerator}
  \./seed : {Seed}
}

class Map extends common.Map
  ->
    super ...
    @seed = Seed.generate!
    @generator = new WorldGenerator(@seed)

  chunk_missing: (cid) ->
    common.pos.ensure_cid cid
    common.log_time "Generation of chunk #{cid} took", ~>
      console.log "Generating chunk #{cid}"
      chunk = @generator.generate_chunk(cid)
      @each_chunk (id, c) ->
        if chunk.eq(c)
          console.log 'Moui grosse problem'
        else
          console.log 'different'
      @set cid, chunk


module.exports = {Map}
