require! './chunk.ls'
require! '../common/pos.ls'

class Map
  chunks: {}
  generator: new chunk.PlainGenerator

  chunk_missing: (cid) ->
    console.log "Generating a new chunk for id #{cid}"
    @generator.generate(cid)

  chunk_by_id: (cid) ->
    unless @chunks[cid]?
      @chunks[cid] = @chunk_missing cid
    @chunks[cid]

  chunk_by_pos: (wpos) ->
    [id, _] = wpos.to_chunk()
    @chunk_by_id id

  each_chunks_in_radius: (cid, radius, f) ->
    for x from cid.x - radius to cid.x + radius
      for y from cid.y - radius to cid.y + radius
        for z from cid.z - radius to cid.z + radius
          iter = pos.chunk_id(x, y, z)
          f @chunk_by_id(iter)

module.exports = {Map}
