class Block
  block_registry = []

  (x, y, z) ->
    @initialize x, y, z

  initialize: ->

  @initialize = ->

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

  @fromJSON = (o) ->
    klass = @registry()[o.id]
    block = new klass
    block.fromJSON(o)
    block

  fromJSON: (o) ->

  toJSON: ->
    id: @id()

  stackable: true
  stack_size: 64

Blocks_ = {}

class Blocks_.Nil extends Block
  @register 0

class Blocks_.Air extends Block
  @register 1

class Blocks_.Ground extends Block
  @register 2

Block <<< Blocks_

module.exports = Block
