require! './chunk.ls'
require! '../common/Map.ls'

export class MapServer extends Map
  generator: new chunk.PlainGenerator

  chunk_missing: (cid) ->
    console.log "Generating a new chunk for id #{cid}"
    @generator.generate(cid)
