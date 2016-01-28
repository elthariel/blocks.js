require! {
  \../common/Map : MapCommon
  \../common/pos
  \./Chunk
}

class Map extends MapCommon

  ->
    @chunk_by_id pos.chunk_id(0 0 0).toString!

  chunk_missing: ->
    @chunks[it] = new Chunk


module.exports = Map
