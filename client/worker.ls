require! {
  '../common' : {Chunk}
  './mesh/greedy_mesher' : GreedyChunkMessher
}

console.log 'Worker started !'

self.addEventListener 'new_chunk', (e) ->
  console.log 'Received message in the worker', e
