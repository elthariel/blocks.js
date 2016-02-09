require! {
  ndarray
  'ndarray-show' : show
  '../../common'
}

# The Culling mesher builds a box for every block that has at least one
# edge visible
# export class CullingChunkMesher
#   ->
#     super ...
#     @_chunk.compute_visible!
#
#   generate: (position, scene) ->
#     mat = new bjs.StandardMaterial('test', scene)
#     @_chunk.each (x, y, z) ~>
#       if @_chunk.get_visible(x, y, z)
#         wpos = vec3(x, y, z).addInPlace position
#         name = "block:#{wpos.x}:#{wpos.y}:#{wpos.z}"
#         console.log name
#
#         mesh = bjs.Mesh.CreateBox(name, {height:1, width:1, depth:1}, scene)
#         mesh.isVisible = true
#         mesh.material = mat
#         mesh.position = wpos

class GreedyWorkBuffer extends common.PackedBitsArray
  @data_type Uint32Array, 3
  @add_field('index', 16)
  @add_field('visible', 6)
  @add_field('meshed', 6)

export class GreedyChunkMesher
  @normals =
    * [1, 0, 0]
    * [-1, 0, 0]
    * [0, 1, 0]
    * [0, -1, 0]
    * [0, 0, 1]
    * [0, 0, -1]

  (@_chunk) ->
    @_work = new GreedyWorkBuffer(@_chunk.size!)
    @_block_ids = []
    @compute_visible!

  get_visible: (x, y, z) ->
    @_work.get_visible(x, y, z)
  get_face_visible: (face_idx, x, y, z) ->
    @_work.get_bit(GreedyWorkBuffer.VISIBLE_OFFSET + face_idx, x, y, z)
  set_face_visible: (face_idx, x, y, z, value) ->
    @_work.set_bit(GreedyWorkBuffer.VISIBLE_OFFSET + face_idx, x, y, z, value)
  get_meshed: (x, y, z) ->
    @_work.get_meshed(x, y, z)
  get_face_meshed: (face_idx, x, y, z) ->
    @_work.get_bit(GreedyWorkBuffer.MESHED_OFFSET + face_idx, x, y, z)
  set_face_meshed: (face_idx, x, y, z, value) ->
    @_work.set_bit(GreedyWorkBuffer.MESHED_OFFSET + face_idx, x, y, z, value)

  # Update the bit field in the merge chunk. Marking as 'visible' every
  # face that touches the boundary of the chunk, air or a transparent block
  compute_visible: ->
    @_chunk.each (x, y, z) ~>
      if @_chunk.get_air(x, y, z)
        return

      id = @_chunk.get_block_id(x, y, z)
      if id not in @_block_ids
        @_block_ids += id

      for idx til @@normals.length
        nx = x + @@normals[idx][0]
        ny = y + @@normals[idx][1]
        nz = z + @@normals[idx][2]

        unless @_chunk.in_chunk(nx, ny, nz)
          @set_face_visible(idx, x, y, z, 1)
          # console.log nx, ny, nz, 'out of chunk'
          continue

        if @_chunk.get_air(nx, ny, nz) or @_chunk.get_transparent(nx, ny, nz)
          # console.log nx, ny, nz, 'air'
          @set_face_visible(idx, x, y, z, 1)

  create_quad: (normal, front, base, du, dv, w) ->
    quad =
      * [base[0],             base[1],             base[2]]
      * [base[0]+du[0],       base[1]+du[1],       base[2]+du[2]]
      * [base[0]+du[0]+dv[0], base[1]+du[1]+dv[1], base[2]+du[2]+dv[2]]
      * [base[0]+dv[0],       base[1]+dv[1],       base[2]+dv[2]]

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


  mesh: (name) ->
    meshes = {}

    for id in @block_ids
      @indices = []
      @vertices = []
      @normals = []
      @uvs = []

      @mesh_id id

      meshes.push {
        indices: @indices
        vertices: @vertices
        normals: @normals
        uvs: @uvs
      }

    meshes

  mesh_id: (id) ->
    # Iterate all 3 dimension. d, u, and v will be the index of the dimensions
    # we iterate. This will allow us to iterate on x/y/z then y/z/x then z/y/x.
    for d til 3
      u = (d + 1) % 3
      v = (d + 2) % 3
      iter = [0, 0, 0]

      # Then for each dimension, we iterate the front and back face
      for front til 2
        face_idx = d * 2 + front
        normal = @@normals[face_idx]

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
