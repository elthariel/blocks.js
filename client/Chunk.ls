require! {
  \../common/Chunk : ChunkCommon
  \./Block
  \./scene
}

class Chunk extends ChunkCommon

  ->
    super!
    scene!createOrUpdateSelectionOctree();


module.exports = Chunk
