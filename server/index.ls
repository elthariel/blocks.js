global import require 'prelude-ls'

require! {
  \./server.ls : {SocketIoServer}
  \./world.ls : {World}
}

console.log 'Starting Blocks server'
world = new World
server = new SocketIoServer(world, 3000)
server.start!
