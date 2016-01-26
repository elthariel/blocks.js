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
        console.log err if err?
        return res.status 500 .send err if err?

        res.status 200 .send "<html><head></head><body><script src=\"/socket.io/socket.io.js\"></script><script>#{assets.toString!}</script></body></html>"

  prepare_client2: ->
    #@app.use express.static __dirname + \/../lta_test/public
    @app.get '/lta', (req, res) ->
      b = browserify extensions: [\.ls \.js]
      b.transform browserify-livescript
      b.add path.resolve __dirname, '../lta_test/index.ls'

      b.bundle (err, assets) ->
        console.log err if err?
        return res.status 500 .send err if err?
        style = '
        <style>
           html, body {
              overflow: hidden;
              width: 100%;
              height: 100%;
              margin: 0;
              padding: 0;
           }
           #renderCanvas {
              width: 100%;
              height: 100%;
              touch-action: none;
           }
        </style>
        '
        res.status 200 .send "<html><head>#{style}</head><body><canvas id='renderCanvas'></canvas><script src=\"/socket.io/socket.io.js\"></script><script>#{assets.toString!}</script></body></html>"

  start: ->
    @prepare_client!
    @prepare_client2!
    @http.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
