export class DSL
  ->
    @tree =
      meshes: {}

  mesh: (id, fun) ->
    console.log "Registering mesh #{id}"
    node = new MeshNode(id)
    fun.apply(node)
    @tree.meshes[id] = node.data


class BaseNode
  ->
    @data = {}
    if @@_defaults?
      @data <<< @@_defaults

  @_defaults = {}
  @keyword = (name, default_value) ->
    @_defaults[name] = default_value

    @.prototype[name] = (value) ->
      @data[attr_name] = value

class MeshNode extends BaseNode
  @keyword 'name'
  @keyword 'air', false
  @keyword 'model', 'cube'
  @keyword 'texture', 'blocks/bedrock.png'
  @keyword 'alpha'
