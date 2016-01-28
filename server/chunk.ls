require! {
  '../common/Block'
  '../common/Chunk' : ChunkCommon
}

class Chunk extends ChunkCommon

class SimpleChunkGenerator
  generate: (cid) ->
    chunk = new Chunk
    chunk.map @~block
    chunk

  block: (x, y, z, b) -> ...
    # throw new Error('Implement me !')

class AirGenerator extends SimpleChunkGenerator
  block: (x, y, z, b) ->
    new Block.Air

class GroundGenerator extends SimpleChunkGenerator
  block: (x, y, z, b) ->
    new Block.Ground

class PlainGenerator
  generate: (cid) ->
    if cid.z >= 0
      gen = new AirGenerator
    else
      gen = new GroundGenerator
    gen.generate(cid)

module.exports = {Chunk, SimpleChunkGenerator, PlainGenerator}
