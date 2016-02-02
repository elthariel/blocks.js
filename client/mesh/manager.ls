require! {
  fs
  path
  './dsl' : {DSL}
}

# We force the path to be included by browserify by requiring
# all the builders. Is it necessary ?
# Also, let's replace this hack with a module or something
for path in fs.readdirSync(__dirname)
  fname = path.basename(path)
  if fname.match(/\w+_builder/)
    require path

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
      m.createInstance(name)

  add_meshes: (id, fun) ->
    console.log "Loading mesh group '#{id}'"
    dsl = new DSL
    fun.apply(dsl)
    @_mesh_data <<< dsl.tree.meshes

  generate_mesh: (id) ->
    data = @_mesh_data[id]
    builder_name = "#{data.model}_builder"
    builder = require("./#{builder_name}")[builder_name]
    builder(@scene, data)


export Manager = new ManagerClass

Manager.add_meshes 'nil', ->
  @mesh 0 ->
    @name 'Nil'
    @air true
    @texture 'blocks/bedrock.png'
