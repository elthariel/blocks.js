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
    @on_pos_change(@pos)

  on_chunk: (msg) ->
    cid = common.pos.chunk_id(msg.pos)
    console.log "Received chunk: ", cid
    @map.set cid, Chunk.fromJSON(msg.chunk)
    @chunk_loading[cid] = false

  on_pos_change: (pos) ->
    [cid, _] = pos.to_chunk!
    unless @map.contains(cid) || @chunk_loading[cid]
      console.log 'Requesting chunk: ', cid
      @chunk_loading[cid] = true
      @socket.emit 'get_chunk', cid
