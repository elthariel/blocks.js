require! {
  ndarray
  './blocks'
}

class Chunk
  const @size = consts.CHUNK_SIZE

  ->
    @blocks = ndarray(new Array(@@size ** 3), [@@size, @@size, @@size])

  fill_from_bitmap: (bitmap) ->
    @map (x, y, z, block) ->
      new (blocks.Base.registry![bitmap[x][y][z]]) x, y, z

  get: (x, y, z) ->
    @blocks.get x, y, z

  get_flat: (i) ->
    @blocks.data[i]

  set: (x, y, z, block) ->
    @blocks.set x, y, z, block

  set_flat: (i, block) ->
    @blocks.data[i] = block

  each: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          f x, y, z, @get(x, y, z)

  each_flat: (f) ->
    for i til @@size ** 3
      f i, @get_flat(i)

  map: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          block = f(x, y, z, @get(x, y, z))
          @set(x, y, z, block)

  map_flat: (fun) ->
    for i til @@size ** 3
      @set_flat i, fun(i, @get_flat(i))

  toJSON: ->
    @blocks.data

  @fromJSON = (json) ->
    chunk = new this
    chunk.fromJSON(json)
    chunk

  fromJSON: (json) ->
    @map_flat (i) ->
      blocks.Base.fromJSON(json[i])

module.exports = {Chunk}
