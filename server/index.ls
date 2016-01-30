global import require 'prelude-ls'

require! {
  \./server.ls
  \./world.ls
}


console.log 'Starting Blocks server'
world = new world.World
server = new server.SocketIoServer(world, 3000)
server.start()
