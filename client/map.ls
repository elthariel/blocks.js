require! {
  \../common
}

export class Map extends common.Map
  (@scene, @socket) ->
    super ...

  chunk_missing: ->
    console.log "Chunk #{it} is missing"
