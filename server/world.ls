
require! {
  \./map.ls
  \./player.ls
  \../common/pos.ls
}

# HasEvents = require('./has_events')

class World #implements HasEvents
  map: new map.Map
  last_player_id: 0
  players: {}

  ->
    @map.each_chunks_in_radius pos.chunk_id(0,0,0), 2, (c) ->
      #console.log c.blocks

  on_new_connection: (socket) ->
    incoming = new player.IncomingPlayer this, socket, @last_player_id
    @last_player_id++

  on_new_player: (socket, id, name) ->
    p = new player.Player(this, socket, id, name)
    @emit_to_all 'player_new', {id: id, name: name}
    @players[p.id] = p

  each_nearby_players: (wpos, radius, f) ->
    @players |> each ->
      if it.pos.in_chunk_radius(radius)
        f it

  emit_to_all: (type, msg) ->
    @players |> each ->
      it.emit type, msg

  emit_to_all_but: (id, type, msg) ->
    @players |> each ->
      if it.id != id
        it.emit(type, msg)

  emit_to_nearby_players: (wpos, radius, type, msg) ->
    @each_nearby_player wpos, radius ->
      it.emit(type, msg)

module.exports = {World}
