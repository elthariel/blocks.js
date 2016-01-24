class Block
  block_registry = []
  @register = (@id) ->
    if block_registry[@id]?
      msg = "There's already a block with id #{@id}: #{that.displayName}"
      throw new Error msg

    block_registry[@id] = this
    console.log "Registered #{@displayName} with id #{id}"

  @registry = ->
    block_registry

class GroundBlock extends Block
  @register 0

class AirBlock extends Block
  @register 1

class GroundBlock extends Block
  @register 2

console.log Block.registry()

#class Block
#  (@id) ->

#class Chunk
#  size: 1000
