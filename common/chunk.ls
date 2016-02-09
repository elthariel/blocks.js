require! {
  \../common
  './packed_bits' : {PackedBitsArray}
}


# A block is represented as a 32 bits unsigned integer, whose bits are
# interpreted as follow:
#
# | block_id | block_variant | air | transparent | unused
# |    14    |      12       |  1  |      1      |   4
export class Chunk extends PackedBitsArray
  @data_type Uint32Array, 3
  @add_field('id', 14)
  @add_field('variant', 12)
  @add_bit('air')
  @add_bit('transparent')
  @add_field('unused', 4)

  (size, @_cid, data = null) ->
    super size, data

  in_chunk: (x, y, z) ->
    0 <= x < @size! and 0 <= y < @size! and 0 <= z < @size!

  cid: ->
    @_cid

  toString: ->
    "#{@_cid}"

  each: (fun) ->
    for x from 0 til @size!
      for y from 0 til @size!
        for z from 0 til @size!
          fun.call(@, x, y, z)



export class SampleChunks
  @cube = (chunk_size, cube_size) ->
    c = new Chunk(chunk_size)
    c.reset!
    c.each (x, y, z) ->
      if x < cube_size and y < cube_size && z < cube_size
        c.set_id x, y, z, 1
      else
        c.set_air x, y, z, 1
    c

  @random = (size, chance) ->
    c = new Chunk(size)
    c.reset!
    c.each (x, y, z) ->
      if Math.random! > chance
        c.set_id x, y, z, 1
      else
        c.set_air x, y, z, 1
    c
