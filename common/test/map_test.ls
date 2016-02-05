require! {
  chai
  '../consts'
  '../pos'
  '../map' : {Map}
}

_it = it
expect = chai.expect

describe 'Map' ->
  cid1 = pos.chunk_id(0, 0, 0)
  cid2 = pos.chunk_id(10, 10, 10)

  _it 'has accessors' ->
    m = new Map
    m.set(cid1, 42)
    expect(m.contains cid1).to.be.true
    expect(m.get cid1).to.eq(42)
