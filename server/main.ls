global import require 'prelude-ls'

require! "./socket_io_server.ls"
require! "./world.ls"

console.log 'Starting Blocks server'
world = new world.World
server = new socket_io_server.SocketIoServer(world, 3000)
server.start()
