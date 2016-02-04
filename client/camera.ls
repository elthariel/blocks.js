require! {
  '../common'
}

export class Camera extends bjs.FreeCamera
  (name, pos, scene, @inputs) ->
    super name, pos, scene

    @checkCollisions = true
    @applyGravity = true
    @ellipsoid = new BABYLON.Vector3(1, 2, 1);
    @minZ = 1
    @maxZ = 2 * 32

    @movement_speed = 0.1
    @rotation_speed = 0.001
    @movements =
      local:
        'move-left': new bjs.Vector3(-@movement_speed, 0, 0)
        'move-right': new bjs.Vector3(@movement_speed, 0, 0)
        'move-up': new bjs.Vector3(0, 0, @movement_speed)
        'move-down': new bjs.Vector3(0, 0, -@movement_speed)
      global:
        'move-jump': new bjs.Vector3(0, 2 * @movement_speed, 0)

    # Initialize movement computation internal data structre
    @local_dir = new bjs.Vector3.Zero!
    @local_trans = new bjs.Matrix
    @transformed_dir = new bjs.Vector3.Zero!

    # Block change detection
    @last_wpos = common.pos.world_pos_from_vec3(pos)


  process_inputs: ->
    # Adds movement relative to the camera angle
    for name, vec of @movements.local
      if @inputs.state[name]
        @local_dir.addInPlace vec

    @getViewMatrix!.invertToRef(@local_trans)
    bjs.Vector3.TransformNormalToRef(@local_dir, @local_trans, @transformed_dir)
    @cameraDirection.addInPlace(@transformed_dir)

    # Add absolute movement
    for name, vec of @movements.global
      if @inputs.state[name]
        @cameraDirection.addInPlace vec

    # Rorate camera
    @cameraRotation.x += @inputs.state.dy * @rotation_speed
    @cameraRotation.y += @inputs.state.dx * @rotation_speed

    # Resets internal state
    @local_dir.x = @local_dir.y = @local_dir.z = 0


  process_movement: ->
    current_wpos = common.pos.world_pos_from_vec3 @position

    # if current_wpos.neq(@last_wpos)
    #   console.log 'New wpos', current_wpos
    #   # on_block_change(current_wpos)
    #
    # if current_wpos.cid().neq(@last_wpos.cid())
    #   console.log 'New cid', current_wpos.cid()
    #   # on_chunk_change(current_wpos.cid())


  tick: ->
    # console.log @inputs.state.dx, @inputs.state.dy
    @process_inputs!
    @process_movement!


  on_pos_change: (@_pos_change) ->

  # _updatePosition: ->
  #   old_wpos = common.pos.world_pos_from_camera_pos @position
  #   super ...
  #   new_wpos = common.pos.world_pos_from_camera_pos @position
  #
  #   if @_pos_change? && new_wpos.neq(old_wpos)
  #     @_pos_change(new_wpos)
