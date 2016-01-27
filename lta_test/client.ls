require! {
  \../common/has_events.ls : HasEvents
  \../common/pos.ls
}

class Client implements HasEvents
  @connect = (@on_ready)->
    new this @on_ready

  (@on_ready) ->
    @register_socket io!
    @events \hello, \welcome

  on_hello: (o) ->
    console.log 'Hello from server'
    @id = o.id
    @emit('hello', 'name')

  on_welcome: (o) ->
    console.log "Client ready, pos #{@pos}"
    @pos = pos.world_pos o
    @on_ready this

  chunk: (cid, on_ready) ->
    @once 'chunk', on_ready
    @emit 'get_chunk', cid

  move: (pos) ->
    @emit('move', pos)

module.exports = {Client}
