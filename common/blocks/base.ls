require! {
  '../registry' : {Registry}
}

Registry.new_category 'block'

export class Base
  block_by_id = []

  @register = (id) ->
    @id = id
    @::id = ->
      id
    Registry.register_block id: id, @

  # Default block is Nil. Will be overriden by Base.register
  id: ->
    0

  eq: (other) ->
    @id! == other.id!

  neq: (other) ->
    not @eq(other)
