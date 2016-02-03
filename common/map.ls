require! {
  \./pos
}

export class Map
  chunks: {}

  chunk_missing: (cid) -> ...

  get: (cid) ->
    unless @chunks[cid]?
      @chunk_missing cid
    @chunks[cid]

  set: (cid, chunk) ->
    @chunks[cid] = chunk

  contains: (cid) ->
    @chunks[cid]?

  get_by_pos: (wpos) ->
    [id, _] = wpos.to_chunk()
    @get id

  each_chunks_in_radius: (cid, radius, f) ->
    for x from cid.x - radius to cid.x + radius
      for y from cid.y - radius to cid.y + radius
        for z from cid.z - radius to cid.z + radius
          iter = pos.chunk_id(x, y, z)
          f @get(iter)
