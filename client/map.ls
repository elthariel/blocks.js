require! {
  \../common
  \./chunk : {Chunk}
}

export class Map extends common.Map
  ->

  chunk_missing: ->
    console.log "Chunk #{it} is missing"
    # @chunks[it] = new Chunk @scene
