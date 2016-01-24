
HasEvents = require './has_events.ls'

class Player implements HasEvents
  (@id, @name, @pos) ->
