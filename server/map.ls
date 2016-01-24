require! './chunk.ls'

class Map
  chunks: {}

  chunk_missing: (id) ->
    console.log "Generating a new chunk for id #{id}"
    generator = new chunk.PlainGenerator
    generator.generate()

  chunk_by_id: (id) ->
    console.log "#{id}"
    unless @chunks[id]?
      @chunks[id] = @chunk_missing id
    @chunks[id]

  chunk_by_pos: (wpos) ->
    [id, _] = wpos.to_chunk()
    @chunk_by_id id
