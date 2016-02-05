require! {
  \./pos
}

export class Map
  ->
    @chunks = {}


  chunk_missing: (cid) -> ...


  get: (cid) ->
    pos.ensure_cid cid
    unless @chunks[cid]?
      @chunk_missing cid
    @chunks[cid]


  set: (cid, chunk) ->
    pos.ensure_cid cid
    @chunks[cid] = chunk


  contains: (cid) ->
    pos.ensure_cid cid
    @chunks[cid]?


  get_by_pos: (wpos) ->
    pos.ensure_wpos wpos
    [cid, _] = wpos.to_chunk!
    @get cid


  each_chunk: (fun) ->
    for key, chunk of @chunks
      fun.call(@, key, chunk)


  each_chunk_in_radius: (cid, radius, f) ->
    for x from cid.x - radius to cid.x + radius
      for y from cid.y - radius to cid.y + radius
        for z from cid.z - radius to cid.z + radius
          iter = pos.chunk_id(x, y, z)
          f.call @, iter, @get(iter)
