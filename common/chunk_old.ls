require! {
  ndarray
  './blocks'
}

class Chunk
  const @size = consts.CHUNK_SIZE

  ->
    @_blocks = ndarray(new Array(@@size ** 3), [@@size, @@size, @@size])

  fill_from_bitmap: (bitmap) ->
    @map (x, y, z, block) ->
      new (blocks.Base.registry![bitmap[x][y][z]]) x, y, z

  get: (x, y, z) ->
    @_blocks.get x, y, z

  get_flat: (i) ->
    @_blocks.data[i]

  set: (x, y, z, block) ->
    @_blocks.set x, y, z, block

  set_flat: (i, block) ->
    @_blocks.data[i] = block

  each: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          f.call @, x, y, z, @get(x, y, z)

  each_flat: (f) ->
    for i til @@size ** 3
      f.call @, i, @get_flat(i)

  eq: (other) ->
    @reduce true (v, i, b) ->
      v and b.eq(other.get_flat(i))

  map: (f) ->
    for x til @@size
      for y til @@size
        for z til @@size
          block = f.call(@, x, y, z, @get(x, y, z))
          @set(x, y, z, block)

  map_flat: (fun) ->
    for i til @@size ** 3
      @set_flat i, fun(i, @get_flat(i))

  reduce: (value, fun) ->
    for i til @@size ** 3
      value = fun.call(@, value, i, @get_flat(i))
    value

  toJSON: ->
    @_blocks.data

  @fromJSON = (json) ->
    chunk = new this
    chunk.fromJSON(json)
    chunk

  fromJSON: (json) ->
    @map_flat (i) ->
      blocks.Base.fromJSON(json[i])

module.exports = {Chunk}
