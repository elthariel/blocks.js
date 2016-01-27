require! './consts.ls'

class Pos
  @size = CHUNK_SIZE
  (@x, @y, @z) ->

  toString: ->
    "#{@x}:#{@y}:#{@z}"

  eq: (other) ->
    @x == other.x && @y == other.y && @z == other.z

  update: (@x, @y, @z) ->

  in_radius: (other_pos, radius) ->
    other_pos.x >= @x - radius && other_pos.x <= @x + radius
      && other_pos.y >= @y - radius && other_pos.y <= @y + radius
      && other_pos.z >= @z - radius && other_pos.z <= @z + radius

class ChunkId extends Pos

class WorldPos extends Pos
  to_chunk: ->
    cid = new ChunkPos Math.floor(@x / @@size),
      Math.floor(@y / @@size),
      Math.floor(@y / @@size)
    cpos = new ChunkId(@x %% @@size, @y %% @@size, @y %% @@size)
    return [cid, cpos]

  in_chunk_radius: (other_pos, chunk_radius) ->
    [cid, _] = @to_chunk!
    [other_cid, _] = other_pos.to_chunk!
    cid.in_radius(other_cid, chunk_radius)

  same_chunk: (other_pos) ->
    [cid, _] = @to_chunk!
    [other_cid, _] = other_pos.to_chunk!
    cid.eq(other_cid)

class ChunkPos extends Pos
  to_world: (cid) ->
    new WorldPos(@x + @@size * cid.x,
      @y + @@size * cid.y,
      @z + @@size * cid.z)

chunk_id = (x, y, z) ->
  if x.x?
    new ChunkId x.x, x.y, x.z
  else
    new ChunkId x, y, z

world_pos = (x, y, z) ->
  if x.x?
    new WorldPos x.x, x.y, x.z
  else
    new WorldPos x, y, z

chunk_pos = (x, y, z) ->
  if x.x?
    new ChunkPos x.x, x.y, x.z
  else
    new ChunkPos x, y, z

module.exports = {chunk_id, world_pos, chunk_pos}

# p1 = world_pos(0, 0, 0)
# p2 = world_pos(32, 0, 0)
# p3 = world_pos(96, 0, 0)
# console.log p1.in_chunk_radius(p1, 2)
# console.log p1.in_chunk_radius(p2, 2)
# console.log p1.in_chunk_radius(p3, 2)
