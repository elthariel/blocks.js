require! {
  path
  express
  http
  browserify
  \browserify-livescript
  \socket.io : io
  \socketio-wildcard : wildcard
}

class SocketIoServer
  (@world, @port) ->
    @app = express()
    @http = http.createServer(@app)
    @io = io(@http)
    @io.use wildcard()

    @io.on 'connection' @~on_connect

  on_connect: (socket) ->
    console.log 'Connection from #{socket}'
    @world.on_new_connection(socket)

  prepare_client: ->
    @app.use express.static __dirname + \/../client/public
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
