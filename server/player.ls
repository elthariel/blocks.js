require! {
  '../common',
}

pos = common.pos

export class IncomingPlayer
  (@world, @socket, @id) ->
    @socket.once 'hello', @~on_hello
    @socket.emit 'hello', id: @id

  on_hello: (o) ->
    @world.on_new_player(@socket, @id, o.name)

export class Player extends common.Player
  (@world, socket, @id, @name) ->
    @register_socket socket
    @events \move, \get_chunk
    @pos = pos.world_pos(10, 16, 10)
    @emit 'welcome', @pos

  emit_to_all: (type, msg) ->
    @world.emit_to_all_but(@id, type, msg)

  emit_to_nearby_players: (type, msg) ->
    @world.emit_to_nearby_players(@pos, 3, type, msg)

  on_get_chunk: (o) ->
    cid = pos.chunk_id(o.x, o.y, o.z)
    chunk = @world.map.get(cid)
    #@emit 'chunk', {pos: cid, chunk: BSON.serialize(chunk}
    @emit 'chunk', BSON.serialize(chunk, false, false, false)

  on_move: (o) ->
    @pos.update(o.x, o.y, o.z)
    @emit_to_nearby_players 'move', {id: @id, pos: @pos}
