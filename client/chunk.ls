require! {
  \../common
  \./block
  \./mesh/manager : {Manager}
}

export class Chunk extends common.Chunk

  (@scene) ->
    super!
    Manager.scene @scene
    @scene.createOrUpdateSelectionOctree!

  show_near_air: (cid) ->
    @each (x, y, z, block) ~>
      if block.id! is 1
        @get_adjacent_blocks x, y, z
          |> filter (.block.id! isnt 1)
          |> each ->
            instance = Manager.instance it.block.id, common.pos.chunk_pos x, y, z
            instance.position = it.pos.to_world cid
            instance.isVisible = true

  get_adjacent_blocks: (x, y, z) ->
    res =
      * pos: common.pos.chunk_pos(x + 1, y, z), block: @get(x + 1, y, z)
      * pos: common.pos.chunk_pos(x, y + 1, z), block: @get(x, y + 1, z)
      * pos: common.pos.chunk_pos(x, y, z + 1), block: @get(x, y, z + 1)
      * pos: common.pos.chunk_pos(x - 1, y, z), block: @get(x - 1, y, z)
      * pos: common.pos.chunk_pos(x, y - 1, z), block: @get(x, y - 1, z)
      * pos: common.pos.chunk_pos(x, y, z - 1), block: @get(x, y, z - 1)

    res |> filter (.block?)

  @fromJSON = (json, scene) ->
    chunk = new this scene
    chunk.fromJSON(json)
    chunk
