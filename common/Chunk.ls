require! './consts.ls'
require! './Block'

class Chunk
  const @size = CHUNK_SIZE

  ->
    # @create_empty_chunk!
    # @fill_from_bitmap do ~>
    #   for x til @@size
    #     for y til @@size
    #       for z til @@size
    #         if y is @@size - 1
    #           1
    #         else
    #           2

  # create_empty_chunk: ->
  #   @blocks = []
  #   for x til @@size
  #     @blocks[x] = []
  #     for y til @@size
  #       @blocks[x][y] = []

  # fill_from_bitmap: (bitmap) ->
  #   @map (x, y, z, block) ->
  #     new (Block.registry![bitmap[x][y][z]]) x, y, z

  get_block: (x, y, z) ->
    # if is-type('Pos', x):
    #   [x, y, z] = x.x, x.y, x.z
    if 0 <= x < CHUNK_SIZE and 0 <= y < CHUNK_SIZE and 0 <= z < CHUNK_SIZE
      @blocks[x][y][z]
    else
      null

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
      b = Block.fromJSON(json[x][y][z])
      #console.log b
      b

  get_adjacent_blocks: (x, y, z) ->
    arr =
      @get_block x + 1, y, z
      @get_block x, y + 1, z
      @get_block x, y, z + 1
      @get_block x - 1, y, z
      @get_block x, y - 1, z
      @get_block x, y, z - 1

    compact arr

module.exports = Chunk
