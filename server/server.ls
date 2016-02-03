require! {
  fs
  path
  express
  http
  browserify
  reload
  \browserify-livescript
  \socket.io : io
}

class SocketIoServer
  (@world, @port) ->
    @app = express()
    @http = http.createServer(@app)
    reload(@http, @app)
    @io = io(@http)
    @io.on 'connection' @~on_connect

  on_connect: (socket) ->
    console.log 'Connection from #{socket}'
    @world.on_new_connection(socket)

  prepare_client: ->
    b = browserify extensions: <[.ls .js]>
    b.transform browserify-livescript
    b.add path.resolve __dirname, '../client/index.ls'
    
    @app.use express.static __dirname + \/../client/public
    @app.use '/bjs', express.static __dirname + \/../client/node_modules/babylonjs
    @app.get \/index.js (req, res) ->
      b.bundle (err, assets) ->
        console.log err if err?
        return res.status 500 .send err if err?
        res.status 200 .send assets

  start: ->
    @prepare_client!
    @http.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
