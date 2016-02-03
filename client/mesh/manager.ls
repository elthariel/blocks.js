require! {
  fs
  path
  './dsl' : {DSL}
  './cube_builder' : {cube_builder}
}

class ManagerClass
  ->
    @_mesh_data = {}
    @_meshes = {}
    @_scene = undefined

  scene: (@_scene) ->

  mesh: (id) ->
    unless @_meshes[id]?
      unless @_mesh_data[id]?
        return @mesh 0
      @_meshes[id] = @generate_mesh id
    @_meshes[id]

  instance: (id, name) ->
    m = @mesh(id)
    if m?
      i = m.createInstance(name)
      i.isVisible = true
      i

  add_meshes: (id, fun) ->
    console.log "Loading mesh group '#{id}'"
    dsl = new DSL
    fun.apply(dsl)
    @_mesh_data <<< dsl.tree.meshes

  generate_mesh: (id) ->
    data = @_mesh_data[id]
    if data.model == 'cube'
      cube_builder @_scene, data
    else
      ...

export Manager = new ManagerClass

Manager.add_meshes 'nil', ->
  @mesh 0 ->
    @name 'Nil'
    @air true
    @texture 'blocks/bedrock.png'

require! './data'
