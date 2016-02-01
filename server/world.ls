
require! {
  \./map
  \./player
  \../common : {pos}
}

class World
  map: new map.Map
  last_player_id: 0
  players: {}

  ->
    @map.each_chunks_in_radius pos.chunk_id(0,0,0), 1, (c) ->
      console.log 'Chunk :', c.blocks

  on_new_connection: (socket) ->
    incoming = new player.IncomingPlayer @, socket, @last_player_id
    @last_player_id++

  on_new_player: (socket, id, name) ->
    p = new player.Player @, socket, id, name
    @emit_to_all 'player_new', {id, name}
    @players[p.id] = p

  each_nearby_players: (wpos, radius, f) ->
    @players
      |> filter (.pos.in_chunk_radius radius)
      |> each f

  emit_to_all: (type, msg) ->
    each (.emit type, msg), @players

  emit_to_all_but: (id, type, msg) ->
    @players
      |> filter (.id isnt id)
      |> each (.emit type, msg)

  emit_to_nearby_players: (wpos, radius, type, msg) ->
    @each_nearby_player wpos, radius, (.emit type, msg)

module.exports = {World}
