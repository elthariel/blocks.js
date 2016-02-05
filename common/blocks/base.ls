class Base
  block_registry = []

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

  # Default block is Nil. Will be overriden by Base.register
  id: ->
    0

  eq: (other) ->
    @id! == other.id!

  neq: (other) ->
    not @eq(other)
module.exports = {Base}
