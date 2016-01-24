class Player
  (@world, @socket, @id) ->
    @socket.on 'move', @~on_move

  on_move: (pos) ->
    @world.notify_all_but(@id, 'move', pos)

class World
  last_player_id: 0
  players: []

  notify_all: (type, msg) ->
    @players |> each ->
      it.socket.emit type, msg

  notify_all_but: (id, type, msg) ->
    @players |> each ->
      if it.id != id
        it.socket.emit(type, msg)

  create_player: (socket) ->
    player = new Player(this, socket, @last_player_id)
    @players[@last_player_id++] = player

require! {
  path
  express
  http
  \socket.io : io
}

class SocketIoServer
  world = new World

  (@port) ->
    @app = express()
    @http = http.createServer(@app)
    @io = io(@http)

    @io.on 'connection' @~on_connect

  on_connect: (socket) ->
    console.log 'Connection from #{socket}'
    world.create_player(socket)

  start: ->
    @app.use(\/, express.static(__dirname + '/../client'))
    @app.get \/ (req, res) -> res.sendFile path.resolve \. \../client/index.html
    @http.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
