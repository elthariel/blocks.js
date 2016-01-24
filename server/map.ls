require! './chunk.ls'
require! '../common/pos.ls'

class Map
  chunks: {}

  chunk_missing: (cid) ->
    console.log "Generating a new chunk for id #{cid}"
    generator = new chunk.PlainGenerator
    generator.generate()

  chunk_by_id: (cid) ->
    console.log "#{cid}"
    unless @chunks[cid]?
      @chunks[cid] = @chunk_missing cid
    @chunks[cid]

  chunk_by_pos: (wpos) ->
    [id, _] = wpos.to_chunk()
    @chunk_by_id id

  each_chunks_in_radius: (cid, radius, f) ->
    for x from cid.x - radius til cid.x + radius
      for y from cid.y - radius til cid.y + radius
        for z from cid.z - radius til cid.z + radius
          cid = pos.chunk_id(x, y, z)
          f @chunk_by_id(cid)
