require! {
  \../common/map : MapCommon
  \../common/pos
  \./Chunk
}

class Map extends MapCommon

  (@scene) ->
    # @chunk_by_id pos.chunk_id(0 0 0).toString!

  chunk_missing: ->
    @chunks[it] = new Chunk @scene

module.exports = Map
