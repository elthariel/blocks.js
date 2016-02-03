require! {
  \../common
  \./block
}

export class Chunk extends common.Chunk

  (@scene) ->
    super!
    @scene.createOrUpdateSelectionOctree!

  show_near_air: ->
    @each (x, y, z, block) ~>
      if block.id! is 1
        @get_adjacent_blocks x, y, z
          |> filter (.id! isnt 1)
          |> each (.instance.isVisible = true)

  @fromJSON = (json, scene) ->
    chunk = new this scene
    chunk.fromJSON(json)
    chunk.show_near_air!
    chunk
