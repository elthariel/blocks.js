require! {
  '../common'
  bson
}

console.log 'bson', bson
BSON = new bson.BSONPure.BSON

class MeshingWorkerClient
  ->
    @_worker = new Worker('worker.js')
    # We transfer the object ownership to the worker thread and we can't use
    # them until they came back. So we'll store them until them.
    @_unusable_chunks = []

  enqueue_chunk: (chunk) ->
    desc =
      size: chunk.size!
      cid: chunk.cid!

    @_worker.postMessage('new_chunk', desc, chunk.data!)


# TODO: load more chunk and deload chunk as needed
export class ChunkLoader implements common.mixins.HasEvents

  (@socket, @map, @pos) ->
    @worker = new MeshingWorkerClient
    @chunk_loading = {}
    @register_socket @socket
    @events 'chunk'
    @on_chunk_change @pos.cid()


  # We received a chunk from socket.io
  on_chunk: (msg) ->
    console.log "Received chunk: ", msg
    cid = common.pos.chunk_id(msg.cid)
    @chunk_loading[cid] = false
    @worker.enqueue_chunk msg


  # Ask for a chunk to be loaded from the server
  load_chunk: (cid) ->
    unless @chunk_loading[cid]
      console.log 'Requesting chunk: ', cid.to_s!
      @chunk_loading[cid] = true
      @emit 'get_chunk', cid


  unload_chunk: (cid) ->
    console.log 'Should unload chunk', cid


  # The camera tell us we moved to a different chunk, let's see if we need
  # to load or unload a chunk
  on_chunk_change: (cid) ->
    console.log 'Chunk change', cid
    common.pos.ensure_cid cid

    # Find chunks outside of our radius and unload them
    @map.each_chunk (key, chunk) ~>
      key = common.pos.chunk_id(key)
      unless key.in_radius(cid, 2)
        @unload_chunk(key)

    # Load new chunks
    @map.each_chunk_in_radius cid, 1, (iter, chunk) ~>
      unless chunk?
        @load_chunk iter
