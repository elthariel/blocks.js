
class SocketIoServer
  express: require('express')()
  http: require('http').Server(@express)
  io: require('socket.io')(@http)

  (@port) ->
    @io.on 'connection', (socket) ~>
      @on_connect socket

  on_connect: (socket) ->
    console.log 'Connection'

  start: ->
    @http.listen @port, ~>
      console.log "Listening on port *:#{@port}"

module.exports = {SocketIoServer}
