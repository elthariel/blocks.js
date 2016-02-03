require! {
  \../common
  \./chunk : {Chunk}
}

export class Map extends common.Map

  (@scene, @socket) ->

  chunk_missing: ->
    console.log "Chunk #{it} is missing"
    console.log @
    @chunks[it] = new Chunk @scene
