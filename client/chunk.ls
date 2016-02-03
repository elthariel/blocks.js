require! {
  \../common
  \./block
  \./mesh/manager : {Manager}
}

export class Chunk extends common.Chunk

  (@scene) ->
    super!
    @scene.createOrUpdateSelectionOctree!

  show_near_air: (cid) ->
    @each (x, y, z, block) ~>
      if block.id! isnt 1
        airs = filter (.id! is 1), @get_adjacent_blocks x, y, z
        if airs.length
          chunkpos = common.pos.chunk_pos x, y, z
          instance = Manager.instance block.id!, '' + cid + chunkpos
          p = (chunkpos.to_world cid)
          instance.position = new bjs.Vector3 p.x, p.y, p.z

  get_adjacent_blocks: (x, y, z) ->

    res =
      * @get(x + 1, y, z) if 0 < x + 1 < consts.CHUNK_SIZE
      * @get(x, y + 1, z) if 0 < y + 1 < consts.CHUNK_SIZE
      * @get(x, y, z + 1) if 0 < z + 1 < consts.CHUNK_SIZE
      * @get(x - 1, y, z) if 0 < x - 1 < consts.CHUNK_SIZE
      * @get(x, y - 1, z) if 0 < y - 1 < consts.CHUNK_SIZE
      * @get(x, y, z - 1) if 0 < z - 1 < consts.CHUNK_SIZE

    compact res

  @fromJSON = (json, scene) ->
    chunk = new this scene
    chunk.fromJSON(json)
    chunk
