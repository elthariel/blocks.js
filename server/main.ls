
require! "./socket_io_server.ls"

console.log "Do something bitch!"
server = new socket_io_server.SocketIoServer(3000)
server.start()
