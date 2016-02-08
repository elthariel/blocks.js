require! {
  ndarray
}

# This class helps you build classes who are containing an array
# containing a structure packed on an unsigned int. Due to Javascript
# limitation, the maximum size of the uing is 32bits
export class PackedBitsArray
  @data_type = (data_type, data_dimension) ->
    @__bitmasks = []
    for bit til 32
      @__bitmasks[bit] = 1 .<<. bit

    @prototype.data_type = ->
      data_type
    @prototype.dimension = ->
      data_dimension

  @__init = ->
    unless @__current_offset?
      @__current_offset = 0

  @add_bit = (name) ->
    @add_field(name, 1)

  @add_field = (name, bits) ->
    @__init!

    offset_key = "#{name.toUpperCase!}_OFFSET"
    mask_key = "#{name.toUpperCase!}_MASK"
    offset = @__current_offset
    mask = (2 ** bits - 1) .<<. offset
    @[offset_key] = offset
    @[mask_key] = mask

    # Add the used bit to the offset
    @__current_offset += bits

    @prototype["get_#{name}"] = (...pos) ->
      @__get_field.apply @, [mask, offset].concat(pos)

    @prototype["set_#{name}"] = (...pos, value) ->
      @__set_field.apply @, [mask, offset].concat(pos).concat(value)

    # Unused yet (and untested)
    # @prototype["reset_#{name}"] = (value) ->
    #   mask = @.constructor[mask_key]
    #   neg_mask = 0xffffffff .^. mask
    #   offset = @.constructor[offset_key]
    #   shifted_value = value .<<. offset .&. mask
    #
    #   for idx til @_array.data.length
    #     old_value = @get_flat.call(@, idx)
    #     new_value = old_value .&. neg_mask .|. shifted_value
    #     @set_flat.call(@, idx, new_value)

  # Generic field getter
  __get_field: (mask, offset, ...pos) ->
    (@get.apply(@, pos) .&. mask) .>>. offset

  # generic field setter
  __set_field: (mask, offset, ...pos, value) ->
    #console.log 'set field', mask.toString(16), offset, pos, value
    neg_mask = 0xffffffff .^. mask

    shifted_value = value .<<. offset .&. mask
    old_value = @get.apply(@, pos)
    new_value = old_value .&. neg_mask .|. shifted_value

    @set.apply(@, pos.concat(new_value))

  get_bit: (bit, ...pos) ->
    @get.apply(@, pos) .&. @constructor.__bitmasks[bit]

  set_bit: (bit, ...pos, value) ->
    mask = @constructor.__bitmasks[bit]
    @__set_field.apply @, [mask, bit].concat(pos).concat(value)

  (@_size) ->
    type = @data_type!
    data = new type(@_size ** @dimension!)

    data_desc = []
    for til @dimension! then data_desc.push(@_size)

    @_array = ndarray(data, data_desc)

  size: ->
    @_size

  get: (...args) ->
    @_array.get.apply(@_array, args)

  get_flat: (idx) ->
    @_array.data[idx]

  set: (...args) ->
    @_array.set.apply(@_array, args)

  set_flat: (idx, value) ->
    @_array.data[idx] = value

  reset: (value = 0) ->
    for i til @_array.data.length
      @_array.data[i] = value
