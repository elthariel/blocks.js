require! './dsl' : {DSL}

class ManagerClass
  ->
    @_mesh_descs = {}
    @_meshes = {}

  mesh: (id) ->
    unless @_meshes[id]?
      unless @_mesh_descs[id]?
        return @mesh 0
      @_meshes[id] = @generate_mesh id
    @_meshes[id]

  instance: (id, name) ->
    @mesh(id).createInstance(name)

  add_meshes: (id, fun) ->
    console.log "Loading mesh group '#{id}'"
    dsl = new DSL
    fun.apply(dsl)
    @_mesh_descs <<< dsl.tree.meshes

  generate_mesh: (id) ->
    console.log 'Implement bjs.createBox xxx with the mesh data'


export Manager = new ManagerClass

Manager.add_meshes 'nil', ->
  @mesh 0 ->
    @name 'Nil'
    @air true
    @texture 'blocks/bedrock.png'
