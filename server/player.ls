require! {
  \../common/pos.ls
  \./has_events.ls : HasEvents
}

class IncomingPlayer implements HasEvents
  (@world, @socket, @id) ->
    @register_socket @socket
    @emit('hello', {id: @id})

  on_hello: (o) ->
    @world.on_new_player(@socket, @id, o.name)

class Player implements HasEvents
  (@world, @socket, @id, @name) ->
    @register_socket @socket
    @pos = pos.world_pos(0, 0, 20)
    @emit 'welcome', @pos

  on_get_chunk: (o) ->
    cid = pos.chunk_id(o.x, o.y, o.z)
    chunk = @world.map.chunk_by_id(cid)
    @emit('chunk', JSON.stringify(chunk))

module.exports = {Player, IncomingPlayer}
