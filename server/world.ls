
require! './map.ls'
require! './player.ls'
require! '../common/pos.ls'

# HasEvents = require('./has_events')

class World #implements HasEvents
  map: new Map
  last_player_id: 0
  players: {}

  on_new_connection: (socket) ->
    incoming = new player.IncomingPlayer this, socket, @last_player_id
    @last_player_id++

  on_new_player: (socket, id, name) ->
    player = new player.Player(this, socket, id, name)
    @emit_to_all 'player_new', {id: id, name: name}
    @players.push player

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
