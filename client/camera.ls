require! {
  '../common'
}

export class Camera extends bjs.FreeCamera
  ->
    super ...
    @checkCollisions = true
    @applyGravity = true
    @ellipsoid = new BABYLON.Vector3(1, 2, 1);    

  on_pos_change: (@_pos_change) ->

  _updatePosition: ->
    old_wpos = common.pos.world_pos_from_camera_pos @position
    super ...
    new_wpos = common.pos.world_pos_from_camera_pos @position

    if @_pos_change? && new_wpos.neq(old_wpos)
      @_pos_change(new_wpos)
