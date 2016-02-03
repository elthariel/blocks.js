class Base
  block_registry = []

  (x, y, z) ->
    @initialize x, y, z

  initialize: ->

  @initialize = ->

  ###############################################
  #### Block Registry

  @register = (id) ->
    @::id = ->
      id

    if block_registry[id]?
      msg = "There's already a block with id #{id}: #{that.displayName}"
      throw new Error msg

    block_registry[id] = this
    console.log "Registered #{@displayName} with id #{id}"

  @registry = ->
    block_registry

  ###############################################
  #### Serialization

  @fromJSON = (o) ->
    klass = @registry()[o.id]
    block = new klass
    block.fromJSON(o)
    block

  fromJSON: (o) ->

  toJSON: ->
    id: @id!

  ###############################################
  #### Meshes

  @create_mesh = -> ...

  @create_instance = ->
    unless @_mesh?
      @_mesh = @create_mesh!
      @_mesh_instance_count = 0
    @_mesh.createInstance("#{@_mesh.name}:#{@_mesh_instance_count++}")

module.exports = {Base}
