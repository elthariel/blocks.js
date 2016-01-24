require! {
  \../common/consts.ls
  \../common/pos.ls
  \./has_events.ls : HasEvents
}

class IncomingPlayer
  (@world, @socket, @id) ->
    @socket.once 'hello', @~on_hello
    @socket.emit 'hello', id: @id

  on_hello: (o) ->
    @world.on_new_player(@socket, @id, o.name)

class Player implements HasEvents
  (@world, @socket, @id, @name) ->
    @register_socket @socket
    @pos = pos.world_pos(0, 0, 20)
    @emit 'welcome', @pos

  emit_to_all: (type, msg) ->
    @world.emit_to_all_but(@id, type, msg)

  emit_to_nearby_players: (type, msg) ->
    @world.emit_to_nearby_players(@pos, 3, type, msg)

  on_get_chunk: (o) ->
    cid = pos.chunk_id(o.x, o.y, o.z)
    console.log "Requested chunk #{cid.toString()}"
    chunk = @world.map.chunk_by_id(cid)
    @emit 'chunk', {pos: cid, chunk: chunk}

  on_move: (o) ->
    @pos.update(o.x, o.y, o.z)
    @emit_to_nearby_players 'move', {id: @id, pos: @pos}

module.exports = {Player, IncomingPlayer}
