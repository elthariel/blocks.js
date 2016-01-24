require! '../common/consts.ls'
require! './block.ls'

class Chunk
  const @size = CHUNK_SIZE
  @nil = new block.NilBlock

  ->
    @blocks = []
    for x til @@size
      @blocks[x] = []
      for y til @@size
        @blocks[x][y] = []
        for z til @@size
          @blocks[x][y][z] = @@nil

  get_block: (x, y, z) ->
    # if is-type('Pos', x):
    #   [x, y, z] = x.x, x.y, x.z
    @blocks[x][y][z]

  set_block: (x, y, z, block) ->
    # if is-type('Pos', x):
    #   block = y
    #   [x, y, z] = x.x, x.y, x.z
    @blocks[x][y][z] = block

  each: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          f x, y, z, @get_block(x, y, z)

  map: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          block = f(x, y, z, @get_block(x, y, z))
          @set_block(x, y, z, block)

  toJSON: ->
    @blocks

  @fromJSON = (json) ->
    chunk = new this
    chunk.fromJSON(json)
    chunk

  fromJSON: (json) ->
    json = JSON.parse json
    @map (x, y, z) ->
      b = block.Block.fromJSON(json[x][y][z])
      #console.log b
      b

class SimpleChunkGenerator
  generate: (cid) ->
    chunk = new Chunk
    chunk.map (x, y, z, b) ~>
      @block x, y, z, b
    chunk

  block: (x, y, z, b) ->
    throw new Error('Implement me !')

class AirGenerator extends SimpleChunkGenerator
    block: (x, y, z, b) ->
      new block.AirBlock

class GroundGenerator extends SimpleChunkGenerator
    block: (x, y, z, b) ->
      new block.GroundBlock

class PlainGenerator
  generate: (cid) ->
    if cid.z >= 0
      gen = new AirGenerator
    else
      gen = new GroundGenerator
    gen.generate(cid)

module.exports = {Chunk, SimpleChunkGenerator, PlainGenerator}
