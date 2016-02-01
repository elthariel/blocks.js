export class DSL
  ->
    @tree =
      meshes: {}

  mesh: (id, fun) ->
    console.log "Registering mesh #{id}"
    @tree.meshes[id] = new MeshNode(id)
    fun.apply(@tree.meshes[id])

class BaseNode
  ->
    if @@_defaults?
      @ <<< @@_defaults

  @_defaults = {}
  @keyword = (name, default_value) ->
    attr_name = "_#{name}"

    @_defaults[attr_name] = default_value

    @.prototype[name] = (value) ->
      @[attr_name] = value

class MeshNode extends BaseNode
  @keyword 'name'
  @keyword 'air', false
  @keyword 'model', false
  @keyword 'texture', 'blocks/bedrock.png'
  @keyword 'alpha', false
