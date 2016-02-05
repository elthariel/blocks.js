export class Pos
  @size = consts.CHUNK_SIZE

  @from_s = (str) ->
    a = str.split(':')
    new @(a[0], a[1], a[2])

  @from_vec3 = (vec3) ->
    new @(vec3.x, vec3.y, vec3.z)

  (@x, @y, @z) ->


  toString: ->
    "#{@x}:#{@y}:#{@z}"


  to_s: ->
    @toString()


  to_a: ->
    [@x, @y, @z]


  eq: (other) ->
    @x == other.x && @y == other.y && @z == other.z


  neq: (other) ->
    @x != other.x || @y != other.y || @z != other.z


  update: (@x, @y, @z) ->


  in_radius: (other_pos, radius) ->
    other_pos.x >= @x - radius && other_pos.x <= @x + radius
      && other_pos.y >= @y - radius && other_pos.y <= @y + radius
      && other_pos.z >= @z - radius && other_pos.z <= @z + radius


class ChunkId extends Pos


class WorldPos extends Pos
  to_chunk: ->
    [@cid(), @cpos()]


  cid: ->
    new ChunkId(Math.floor(@x / @@size),
      Math.floor(@y / @@size),
      Math.floor(@z / @@size))


  cpos: ->
    new ChunkPos(@x %% @@size, @y %% @@size, @z %% @@size)


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
    ensure_cid cid
    new WorldPos(@x + @@size * cid.x,
      @y + @@size * cid.y,
      @z + @@size * cid.z)


export chunk_id = (x, y, z) ->
  if x.split?
    ChunkId.from_s x
  else if x.x?
    ChunkId.from_vec3 x
  else
    new ChunkId x, y, z


export world_pos = (x, y, z) ->
  if x.split?
    WorldPos.from_s x
  else if x.x?
    WorldPos.from_vec3 x
  else
    new WorldPos x, y, z


export chunk_pos = (x, y, z) ->
  if x.split?
    ChunkPos.from_s x
  else if x.x?
    ChunkPos.from_vec3 x
  else
    new ChunkPos x, y, z


export world_pos_from_vec3 = (camera_pos) ->
  x = Math.floor camera_pos.x
  y = Math.floor camera_pos.y
  z = Math.floor camera_pos.z
  new WorldPos(x, y, z)


export ensure_wpos = (p) ->
  unless p instanceof WorldPos
    console.log p, "is not a ChunkPos"


export ensure_cid = (p) ->
  unless p instanceof ChunkId
    console.log p, "is not a ChunkPos"


export ensure_cpos = (p) ->
  unless p instanceof ChunkPos
    console.log p, "is not a ChunkPos"
