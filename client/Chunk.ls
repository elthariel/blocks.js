require! {
  \../common/chunk : ChunkCommon
  \./Block
  # \./scene
}

class Chunk extends ChunkCommon

  (@scene) ->
    super!
    scene.createOrUpdateSelectionOctree();
    @show_near_air!

  show_near_air: ->
    @each (x, y, z, block) ~>
      if block.id! is 1
        @get_adjacent_blocks x, y, z
          |> filter (.id! isnt 1)
          |> each (.instance.isVisible = true)

module.exports = Chunk
