require! {
  chai
  '../consts'
  '../pos'
  '../chunk' : {Chunk}
  '../blocks'
}

_it = it
expect = chai.expect

describe 'Chunk' ->
  _it 'works' ->
    c1 = new Chunk
    c2 = new Chunk
    c3 = new Chunk
    c1.map ->
      new blocks.Nil
    c2.map ->
      new blocks.Nil
    c3.map ->
      new blocks.Dirt

    b1 = new blocks.Dirt
    b2 = new blocks.Dirt
    b3 = new blocks.Nil
    expect(b1.eq b2).to.be.true
    expect(b1.neq b3).to.be.true
    expect(c1.eq c2).to.be.true
    expect(c1.eq c3).to.be.false
