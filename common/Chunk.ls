require! './consts.ls'
require! './Block'

class Chunk
  const @size = CHUNK_SIZE
  @index_from_xyz = (x, y, z) ->
    x + @size * y + @size * @size * z

  ->
    @blocks = new Array(@@size ** 3)
    @fill_from_bitmap do ~>
      for x til @@size
        for y til @@size
          for z til @@size
            0

  fill_from_bitmap: (bitmap) ->
    @map (x, y, z, block) ->
      new (Block.registry![bitmap[x][y][z]]) x, y, z

  get: (x, y, z) ->
    # Thanks for deleting my code
    # if is-type('Pos', x):
    #   [x, y, z] = x.x, x.y, x.z
    @blocks[@@index_from_xyz x, y, z]

  set: (x, y, z, block) ->
    # if is-type('Pos', x):
    #   block = y
    #   [x, y, z] = x.x, x.y, x.z
    @blocks[@@index_from_xyz x, y, z] = block

  each: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          f x, y, z, @get(x, y, z)

  map: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          block = f(x, y, z, @get(x, y, z))
          @set(x, y, z, block)

  toJSON: ->
    @blocks

  @fromJSON = (json) ->
    chunk = new this
    chunk.fromJSON(json)
    chunk

  fromJSON: (json) ->
    json = JSON.parse json
    @map (x, y, z) ->
      b = Block.fromJSON(json[x][y][z])
      #console.log b
      b

module.exports = Chunk
