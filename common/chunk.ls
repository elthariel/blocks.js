require! {
  \./consts.ls
  \./Block
  ndarray
}

class Chunk
  const @size = CHUNK_SIZE

  ->
    @blocks = ndarray new Array(@@size ** 3), [@@size, @@size, @@size]

    # Let's get rid of this pretty soon ;)
    @fill_from_bitmap do ~>
      for x til @@size
        for y til @@size
          for z til @@size
            0

  fill_from_bitmap: (bitmap) ->
    @map (x, y, z, block) ->
      new (Block.registry![bitmap[x][y][z]]) x, y, z

  get: (x, y, z) ->
    @blocks.get x, y, z

  set: (x, y, z, block) ->
    @blocks.set x, y, z, block

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
      Block.fromJSON(json[x][y][z])

module.exports = Chunk
