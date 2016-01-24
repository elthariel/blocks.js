class Player
  (@world, @socket, @id) ->
    @socket.on 'move', (msg) ~>
      @on_player_move msg.split(':')
    @socket.on 'hello', (msg) ~>
      @on_hello(msg)

  on_move: (x, y, z) ->
    @world.notify_all_but(@id, 'player_moved', "#{@id}:#{x}:#{y}:#{z}")

  on_hello: ->
    console.log("Player #{@id} says hello !!!")


class World
  last_player_id: 0
  players: []

  notify_all: (type, msg) ->
    @players |> each ->
      it.emit type, msg

  notify_all_but: (id, type, msg) ->
    @players |> each ->
      if it.id != id
        it.emit(type, msg)

  create_player: (socket) ->
    player = new Player(this, socket, @last_player_id)
    @last_player_id += 1

    notify_all 'new_player', player.id

require! 'path'
require! 'express'
require! 'http'
io = require 'socket.io'

class SocketIoServer
  world = new World

  (@port) ->
    @app = express()
    @http = http.createServer(@app)
    @io = io(@http)

    @io.on 'connection', (socket) ~>
      @on_connect socket

  on_connect: (socket) ->
    console.log 'Connection from #{socket}'
    @world.create_player(socket)

  start: ->
    @app.use(express.static(__dirname + '/public'))    
    @app.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
