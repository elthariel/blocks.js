require! {
  path
  express
  http
  browserify
  \browserify-livescript
  \socket.io : io

}

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

  prepare_client: ->
    @app.use express.static __dirname + \../client/public
    b = browserify extensions: [\.ls \.js]
    b.transform browserify-livescript
    b.add path.resolve __dirname, '../client/test.ls'
    @app.get \/ (req, res) ->
      b.bundle (err, assets) ->
        console.log err
        return res.status 500 .send err if err?

        res.status 200 .send "<html><head></head><body><script src=\"/socket.io/socket.io.js\"></script><script>#{assets.toString!}</script></body></html>"

  start: ->
    @prepare_client!
    @http.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
