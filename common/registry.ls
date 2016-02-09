
# Registry.new_category 'mat'
# Registry.register_mat id: 1, name: 'test_mat', value
# Registry.get_mat 1
# Registry.get_mat 'test_mat'
export class Registry
  @data = {}

  @log = (...msgs) ->
    console.log.apply(console, ['Registry:'].concat msgs)

  @new_category = (name) ->
    if @data[name]?
      # Already registered
      return

    @log 'Registering category', name
    @data[name] =
      by_id: []
      by_name: {}

    @[name] = (id_or_name) ->
      @get name, id_or_name

    @['register_' + name] = (opts, value) ->
      @register name, opts, value

  @get = (category, id_or_name) ->
    @data[category].by_id[id_or_name] || @data[category].by_name[id_or_name]

  @register = (category, opts, value) ->
    unless opts.id?
      throw new Error('You have to specify an id')

    unless opts.name?
      if value.name?
        if typeof value.name == 'function'
          opts.name = value.name!
        else
          opts.name = value.name
      else if value.displayName?
        opts.name = value.displayName

    @log 'new', category, ':', opts.name, opts.id
    if @data[category].by_id[opts.id]?
      msg = "There's already a #{id_or_name} #{category} registered"
      throw new Error msg

    @data[category].by_id[opts.id] = value
    if opts.name?
      @data[category].by_name[opts.name] = value
