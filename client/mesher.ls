require! {
  ndarray
  'ndarray-show' : show
  './packed_bits' : {PackedBitsArray}
}

# unless window?
#   global.window = {}
#   global.navigator = {}
#   bjs = require 'babylonjs'

Vec3 = bjs.Vector3
vec3 = (x, y, z) ->
  new Vec3(x, y, z)

Vec2 = bjs.Vector3
vec2 = (x, y) ->
  new Vec2(x, y)

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

class ChunkMergeBuffer extends PackedBitsArray
  @data_type Uint32Array, 3
  @add_field('index', 16)
  @add_field('visible', 6)
  @add_field('meshed', 6)

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
  @normals =
    * [1, 0, 0]
    * [-1, 0, 0]
    * [0, 1, 0]
    * [0, -1, 0]
    * [0, 0, 1]
    * [0, 0, -1]

  ->
    super ...
    @_merge = new ChunkMergeBuffer(@size!)
    @_block_ids = []
    @_merge.reset!

  # Update the bit field in the merge chunk. Marking as 'visible' every
  # face that touches the boundary of the chunk, air or a transparent block
  compute_visible: ->
    @each (x, y, z) ~>
      if @get_air(x, y, z)
        return

      id = @get_block_id(x, y, z)
      if id not in @_block_ids
        @_block_ids += id

      for idx til @@normals.length
        nx = x + @@normals[idx][0]
        ny = y + @@normals[idx][1]
        nz = z + @@normals[idx][2]

        unless @in_chunk(nx, ny, nz)
          @set_face_visible(idx, x, y, z, 1)
          # console.log nx, ny, nz, 'out of chunk'
          continue

        if @get_air(nx, ny, nz) or @get_transparent(nx, ny, nz)
          # console.log nx, ny, nz, 'air'
          @set_face_visible(idx, x, y, z, 1)


  get_visible: (x, y, z) ->
    @_merge.get_visible(x, y, z)

  get_face_visible: (face_idx, x, y, z) ->
    @_merge.get_bit(ChunkMergeBuffer.VISIBLE_OFFSET + face_idx, x, y, z)

  set_face_visible: (face_idx, x, y, z, value) ->
    @_merge.set_bit(ChunkMergeBuffer.VISIBLE_OFFSET + face_idx, x, y, z, value)


  get_meshed: (x, y, z) ->
    @_merge.get_meshed(x, y, z)

  get_face_meshed: (face_idx, x, y, z) ->
    @_merge.get_bit(ChunkMergeBuffer.MESHED_OFFSET + face_idx, x, y, z)

  set_face_meshed: (face_idx, x, y, z, value) ->
    @_merge.set_bit(ChunkMergeBuffer.MESHED_OFFSET + face_idx, x, y, z, value)


  in_chunk: (x, y, z) ->
    0 <= x < @size! and 0 <= y < @size! and 0 <= z < @size!

  each: (fun) ->
    for x from 0 til @size!
      for y from 0 til @size!
        for z from 0 til @size!
          fun.call(@, x, y, z)

class IndiceArray extends PackedBitsArray
  @data_type Uint16Array, 2
  @add_field('vertex_id', 12)

export class ChunkMesher
  (@_chunk) ->

  generate: (position, scene) -> ...

# The Culling mesher builds a box for every block that has at least one
# edge visible
export class CullingChunkMesher extends ChunkMesher
  ->
    super ...
    @_chunk.compute_visible!

  generate: (position, scene) ->
    mat = new bjs.StandardMaterial('test', scene)
    @_chunk.each (x, y, z) ~>
      if @_chunk.get_visible(x, y, z)
        wpos = vec3(x, y, z).addInPlace position
        name = "block:#{wpos.x}:#{wpos.y}:#{wpos.z}"
        console.log name

        mesh = bjs.Mesh.CreateBox(name, {height:1, width:1, depth:1}, scene)
        mesh.isVisible = true
        mesh.material = mat
        mesh.position = wpos

# export class TestMesh extends ChunkMesher
#   ->
#     super ...
#     @_chunk.compute_visible!
#
#   generate: (position, scene) ->
#     vertices = []
#     indices = []
#     z = 0
#
#     open_block = [-1, -1]
#     for x til @_chunk.size!
#       if open_block[0] >= 0
#         console.log 'Closing block', open_block, x, y
#         open_block = [-1, -1]
#
#       for y til @_chunk.size!
#         if open_block[0] >= 0 and not @_chunk._merge.get_bit(5, x, y, z)
#           console.log 'Closing block', open_block, x, y
#           open_block = [-1, -1]
#
#         if open_block[0] == -1 and @_chunk._merge.get_bit(5, x, y, z)
#           console.log 'Open Block', x, y
#           open_block = [x, y]

export class GreedyChunkMesher extends ChunkMesher
  ->
    super ...
    @_chunk.compute_visible!
    @vertices = []
    @indices = []
    @normals = []
    @uvs = []

  create_quad: (normal, front, base, du, dv, w) ->
    quad =
      * [base[0],             base[1],             base[2]]
      * [base[0]+du[0],       base[1]+du[1],       base[2]+du[2]]
      * [base[0]+du[0]+dv[0], base[1]+du[1]+dv[1], base[2]+du[2]+dv[2]]
      * [base[0]+dv[0],       base[1]+dv[1],       base[2]+dv[2]]

    #console.log '(base,du,dv)=', base, du, dv, 'new_quad', quad

    idx = @vertices.length / 3
    for point in quad
      for i til 3
        @vertices.push point[i]
        @normals.push normal[i]

    @uvs.push 0, 0
    @uvs.push 0, 1
    @uvs.push w, 1
    @uvs.push w, 0

    if front
      @indices.push(idx, idx + 1, idx + 2)
      @indices.push(idx, idx + 2, idx + 3)
    else
      @indices.push(idx, idx + 2, idx + 1)
      @indices.push(idx, idx + 3, idx + 2)


  generate: (id) ->
    # Iterate all 3 dimension. d, u, and v will be the index of the dimensions
    # we iterate. This will allow us to iterate on x/y/z then y/z/x then z/y/x.
    for d til 3
      u = (d + 1) % 3
      v = (d + 2) % 3
      iter = [0, 0, 0]

      # Then for each dimension, we iterate the front and back face
      for front til 2
        face_idx = d * 2 + front
        normal = Chunk.normals[face_idx]

        # We then iterate from 0 to size on 3 axis, using the previously
        # defined dimension index to compute the position we're at in the
        # direction we're iterating
        for i til @_chunk.size!
          iter[d] = i

          for j til @_chunk.size!
            iter[u] = j

            for k til @_chunk.size!
              # iter now have the chunk position of the block we're looking at
              # and will progress in the correct order for the direction we're
              # iterating.
              iter[v] = k
              du = [0, 0, 0]
              dv = [0, 0, 0]
              du[u] = 1

              # Here we look for adjacent faces to merge
              # FIXME: We only do it in one direction now
              iter2 = iter.slice(0)
              w = 0
              for k2 from k til @_chunk.size!
                iter2[v] = k2
                visible = @_chunk.get_face_visible face_idx, iter2[0], iter2[1], iter2[2]
                meshed = @_chunk.get_face_meshed face_idx, iter2[0], iter2[1], iter2[2]

                if visible and not meshed
                  @_chunk.set_face_meshed face_idx, iter2[0], iter2[1], iter2[2], 1
                  dv[v]++; w++
                  # console.log 'should create quad', dv[v]
                else
                  break

              if du[u] and dv[v]
                base = iter.slice(0)
                unless front
                  base[d] += 1

                @create_quad(normal, front, base, du, dv, w)


  mesh: (scene) ->
    vxd = new bjs.VertexData
    vxd.indices = @indices
    vxd.positions = @vertices
    vxd.normals = @normals
    vxd.uvs = @uvs

    mesh = new bjs.Mesh 'name', scene
    vxd.applyToMesh mesh, false
    mesh.freezeWorldMatrix!


    # console.log @positions
    # console.log @indices

    mesh


# c = SampleChunks.cube(3, 3)
# # c = SampleChunks.random(5, 0.2)
# m = new GreedyChunkMesher c
# m.generate!
#console.log m.indices
#for i til m.vertices.length / 3
#  console.log m.vertices[i * 3], m.vertices[i * 3 + 1], m.vertices[i * 3 + 2]

#c.set_id(0, 0, 0, 1)
#console.log (c.get(0, 0, 0).toString(16))
#console.log Chunk
# c = new Chunk(4)
# c.reset!
# c.set_transparent(2, 2, 2, 1)
#console.log c.get(2, 2, 2).toString(16)
#console.log c.get_transparent(2, 2, 2)
#console.log c.get_air(2, 2, 2)
#c._merge.set_flat(0, 0xffff)
#c._merge.set_bit(0, 0, 0, 0, 1)
#console.log show(c._array)
#console.log show(c._merge._array.data)
#console.log c._merge.get_visible(1, 1, 1).toString(2)
