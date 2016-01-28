require! './chunk.ls'
require! '../common/Map': MapCommon

export class Map extends MapCommon
  generator: new chunk.PlainGenerator

  chunk_missing: (cid) ->
    console.log "Generating a new chunk for id #{cid}"
    @generator.generate(cid)
