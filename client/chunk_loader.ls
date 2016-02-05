require! {
  '../common'
  './chunk' : {Chunk}
}

# TODO: load more chunk and deload chunk as needed
export class ChunkLoader implements common.mixins.HasEvents

  (@socket, @map, @pos) ->
    @chunk_loading = {}
    @register_socket @socket
    @events 'chunk'
    @on_chunk_change @pos.cid()


  on_chunk: (msg) ->
    cid = common.pos.chunk_id(msg.pos)
    console.log "Received chunk: ", cid #msg
    @map.set cid, chunk = Chunk.fromJSON(msg.chunk, @map.scene)
    chunk.show_near_air cid
    @chunk_loading[cid] = false


  load_chunk: (cid) ->
    unless @chunk_loading[cid]
      @chunk_loading[cid] = true
      console.log 'Requesting chunk: ', cid.to_s!
      @emit 'get_chunk', cid


  unload_chunk: (cid) ->
    console.log 'Should unload chunk', cid


  on_chunk_change: (cid) ->
    console.log 'Chunk change', cid
    common.pos.ensure_cid cid

    # Find chunks outside of our radius and unload it
    @map.each_chunk (key, chunk) ~>
      key = common.pos.chunk_id(key)
      unless key.in_radius(cid, 2)
        @unload_chunk(key)

    # Load new chunks
    @map.each_chunk_in_radius cid, 1, (iter, chunk) ~>
      unless chunk?
        @load_chunk iter


  on_pos_change: (pos) ->
    [cid, _] = pos.to_chunk!

    unless @map.contains(cid) || @chunk_loading[cid]
      console.log 'Requesting chunk: ', cid.toString()

      @socket.emit 'get_chunk', cid
