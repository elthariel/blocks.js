
class InventoryCell
  @_content: undefined
  @_amount: 0

  count: ->
    @_amount

  block: ->
    @_content

  empty: ->
    @_amount == 0

  swap: (cell) ->
    tmp_content = cell._content
    tmp_amount = cell._amount
    cell._content = @_content
    cell._amount = @_amount
    @_content = tmp_content
    @_amount = tmp_amount

  add: (block) ->
    if @_amount == 0
      @_content = block
      @_amount = 1
      return @_amount
    else if @content.id() == block.id()
      if block.stackable && @amount < block.stack_size
        @amount++
        return @amount
    false

class Inventory
  (@width, @height) ->
    @blocks = []
    for x from 0 til @width
      @blocks[x] = []

  at: (x, y) ->
    if x < @width && y < @height
      @blocks[x][y]

  put: (x, y, block) ->
    if x < @width && y < @height
      item = @at(x, y)
      if !item
        @blocks[x][y] = block
