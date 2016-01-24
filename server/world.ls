
require! './map.ls'
require! './player.ls'
require! '../common/pos.ls'

HasEvents = require('./has_events')

class World implements HasEvents
  map: new Map
  players: []

  register_player: (player) ->
    @players.push player

  each_nearby_players: (wpos, radius, f) ->
