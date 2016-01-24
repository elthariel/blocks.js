class Block
  block_registry = []
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

class NilBlock extends Block
  @register 0

class AirBlock extends Block
  @register 1

class GroundBlock extends Block
  @register 2

module.exports = {Block, NilBlock, AirBlock, GroundBlock}
